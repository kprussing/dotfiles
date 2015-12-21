#!/usr/bin/env python
__doc__="""
A testing script to see if I can work with Outlook calendar requests.
The ultimate goal will be to view and then respond using mutt.  I'm not
sure how that last part will work.  Maybe I could write an interactive
mode that would (a)ccept, (r)eject, accept with (c)omment, or (q)uit.
It would also be nice to add the item to a `remind` script.  At some
point, I need to dig into the Calendar folder on the Exchange server and
see what's up there.

The default behavior if no action is selected is to simply print the
invitation to the standard output.

"""

import argparse
import copy
import logging
import os
import re
import textwrap

import icalendar

class Time:
    """A class to help format the time

    This simply holds a reference to a :class:`datetime.datetime` and
    offers a way to quickly print the time.

    Parameters
    ----------

    datetime: :class:`datetime.datetime`
        The target time object
    strftime: str, optional
        The desired date/time format.

    """

    def __init__(self, datetime, strftime="%Y-%m-%d %H:%M"):
        self.datetime = datetime
        self.strftime = strftime

    def __str__(self):
        return self.datetime.strftime(self.strftime)


class Invite:
    """A class to interface with an invitation.

    This provides worker methods to access the properties of the given
    invitation.

    Parameters
    ----------

    calendar: :class:`icalendar.cal.Calendar`
        The calendar invitation with which to work
    indent: int, optional
        The indent level of the fields for printing
    width: int, optional
        The width of the terminal for printing
    strftime: str, option
        A valid :class:`datetime` format string

    """

    def __init__(
                self, calendar, indent=4, width=70, 
                strftime="%Y-%m-%d %H:%M"
            ):
        self.calendar = calendar
        self.indent = indent
        self.width = width
        self.strftime = strftime
        self.event = None
        for comp in self.calendar.subcomponents:
            if isinstance(comp, (icalendar.Event,)):
                # This assumes there is only one event in the calendar
                # and will grab the last event.
                self.event = comp

    @staticmethod
    def format_person(field):
        """Format the person for pretty printing.
        
        If the field is `None`, `None` is returned.

        Parameters
        ----------

        field: :class:`icalendar.vCalAddress`
            The address to pretty print.

        """
        if field is None:
            return None

        name = field.params.get("cn", "")
        if name == "":
            outfmt = "{0}"
        else:
            outfmt = name + " <{0}>"

        email = re.sub(
                "mailto:", "", field.to_ical().decode(),
                flags=re.IGNORECASE
            )
        return outfmt.format(email)

    def format_field(self, key):
        """Generate a formatted field

        This returns a string with of the item formatted for printing.
        The key has the first character uppercased and the value of the
        field is wrapped to the target width and indented appropriately.

        Parameters
        ----------

        key: str
            The string key in the event.

        """
        out = key[0].upper() + key[1:].lower() + ":" + os.linesep
        replace_whitespace = True
        if key.lower() == "organizer":
            text = Invite.format_person(self.event.get(key, None))
            text = text if text is not None else "Unknown"
        else:
            text = self.event.get(key, "")

        fmt = textwrap.TextWrapper(
                width=self.width, initial_indent=" "*self.indent, 
                subsequent_indent=" "*self.indent, 
                replace_whitespace=replace_whitespace
            )
        out += os.linesep.join(fmt.wrap(text.strip()))
        return out

    @property
    def header(self):
        """A formatted header."""
        lines = (
                "=" * self.width,
                "{0:^"  + str(self.width) + "}",
                "=" * self.width
            )
        return os.linesep.join(lines).format("Calendar Event")

    @property
    def summary(self):
        """The summary string."""
        return self.format_field("Summary")

    @property
    def organizer(self):
        """The organizer string."""
        return self.format_field("Organizer")

    @property
    def description(self):
        """The description string."""
        return self.format_field("Description")

    @property
    def attendees(self):
        """The list of attendees."""
        items = self.event.get("Attendee", None)
        if items is None:
            return None

        out = (os.linesep + " " * self.indent).join(
                ["Attendees:"] + [Invite.format_person(x) for x in items]
            )
        return out

    @property
    def start(self):
        """The start date/time."""
        try:
            start = self.event["DTSTART"]
        except KeyError:
            raise RuntimeError("No start time in invite!")

        return Time(start.dt, self.strftime)

    @property
    def end(self):
        """The end date/time."""
        try:
            end = self.event["DTEND"]
        except KeyError:
            raise RuntimeError("No end time in invite!")

        return Time(end.dt, self.strftime)

    @property
    def location(self):
        """The location of the event."""
        return self.format_field("Location")

    @property
    def duration(self):
        """Format the duration."""
        out = "Duration:" + os.linesep + " " * self.indent
        return out + str(self.start) + " until " + str(self.end)

    def pprint(self, attendees=False):
        """Pretty print the invite.

        Parameters
        ----------

        attendees: bool, optional
            Print the attendees in the string.

        """
        fields = [
                self.header,  self.summary, self.organizer,
                self.duration, self.location, self.description,
            ]
        if attendees:
            fields += [self.attendees]

        return os.linesep.join(fields)

    def to_remind(self):
        """Generate a remind(1) command."""
        strftime = "%Y-%m-%d AT %H:%M"
        start = self.start.datetime.strftime(strftime)
        # end = self.end.datetime.strftime(strftime)
        # Set a warning for 15 minutes before and every 5 minutes after
        # that.
        warn = "+15 *5"
        summary = self.event["Summary"].strip()
        msg = 'REM {start} {warn} MSG %"{summary}%" %1%'
        return msg.format(start=start, warn=warn, summary=summary)

    def reply(self, accept):
        """Generate the reply response.

        Update the fields based on the acceptance ore rejection.

        Parameters
        ----------

        accept: bool
            Accept the invitation?

        """
        response = copy.deepcopy(self.calendar)
        revent = None
        for comp in response.subcomponents:
            if isinstance(comp, (icalendar.Event,)):
                # This assumes there is only one event in the calendar
                # and will grab the last event.
                revent = comp

        response["Method"] = b"REPLY"
        summary = "{0}: {1}".format(
                "Accepted" if accept else "Declined", revent["Summary"]
            )
        revent["Summary"] = icalendar.prop.vText(summary)
        return response


if __name__ == "__main__":
    """Do stuff"""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
            "ICAL", help="The invitation file", 
            type=argparse.FileType("r")
        )

    # Execution options
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
            "-r", "--remind", action="store_true",
            help="Generate a remind(1) command from the invite"
        )

    # Debug/Verbosity flags.
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
            "-v", "--verbose", action="store_true", 
            help="Verbose output"
        )
    group.add_argument(
            "-d", "--debug", action="store_true", help="Debug output"
        )
    args = parser.parse_args()

    if args.debug:
        level = logging.DEBUG
    elif args.verbose:
        level = logging.INFO
    else:
        level = logging.WARNING

    logging.basicConfig(level=level)

    cal = icalendar.cal.Calendar.from_ical(args.ICAL.read())
    inv = Invite(cal)
    if args.remind:
        print(inv.to_remind())
    else:
        print(inv.pprint(attendees=args.verbose))

