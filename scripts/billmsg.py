#!/usr/bin/env python
from __future__ import print_function

__doc__="""
Check to see if the given BILL due on DAY has been paid and generate the
remind(1) message if it has not.  The first step it to ensure the
previous bill has been paid.  After that, the date is compared against
the next possible due date to see if that bill is due in the next OFFSET
days or has already been paid.  The logic is that if the bill was paid
for YEAR-MONTH, then I printed out a PDF of the confirmation and placed
in in a directory YEAR/MONTH where the month is zero padded.  This
directory is assumed to be under BILLDIR.  If the PDF does not exist,
then MSG is sent to the standard output.  The effective check date can
be set with the TODAY flag.  If the optional argument -c is present,
then a call to ledger(1) is made to check if the balance is zero.  It
the balance is zero, nothing is printed.  NOTE: This assumes you use the
same name for the saved payment confirmations as you do in ledger(1)!
If the bimonthly flag -z is set, this will look for the payment receipt
in either (e)ven or (o)dd month directories.

"""

import argparse
import datetime
import logging
import os
import subprocess
import sys

import dateutil.relativedelta

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument(
            "BILL", help="The bill to check."
        )
    parser.add_argument(
            "DAY", type=int, help="The day the bill is due."
        )
    parser.add_argument(
            help="The remind(1) message", nargs="+", dest="msg",
            metavar="MSG", 
        )

    parser.add_argument(
            "-b", help="Bill payment directory", metavar="BILLDIR",
            dest="billdir", default=os.path.join(
                os.path.expanduser("~"), "Documents", "Bills"
            )
        )
    parser.add_argument(
            "-o", help="Number of days to report due.",
            type=int, default=7, metavar="OFFSET", dest="offset"
        )
    parser.add_argument(
            "-t", help="ISO day YYYY-MM-DD.", metavar="TODAY",
            dest="today"
        )
    parser.add_argument(
            "-c", action="store_true", 
            help="Check ledger(1) for a credit card balance."
        )
    parser.add_argument(
            "-z", help="Bimonthly.  (E)ven or (o)dd month.", 
            dest="zweimon", choices=("e", "o")
        )

    group = parser.add_mutually_exclusive_group()
    group.add_argument(
            "-v", "--verbose", help="Extra output", action="store_true"
        )
    group.add_argument(
            "-d", "--debug", help="Debug output", action="store_true"
        )

    args = parser.parse_args()

    if args.debug:
        level = logging.DEBUG
    elif args.verbose:
        level = logging.INFO
    else:
        level = logging.WARNING

    logging.basicConfig(level=level)
    logging.debug(args)

    if args.today is None:
        date = datetime.datetime.today()
    else:
        try:
            date = datetime.datetime.strptime(args.today, "%Y-%m-%d")
        except ValueError:
            msg = "Invalid date passed to TODAY: {0}".format(args.today)
            logging.error(msg)
            sys.exit(1)

    logging.debug("Checking for date: {0}".format(date))
    if args.c:
        cmd = ["ledger", "balance", '"' + args.BILL + '"']
        logging.info("Check ledger(1) for a balance")
        logging.debug("Using command: {0}".format(" ".join(cmd)))
        try:
            output = subprocess.check_output(cmd)
        except subprocess.CalledProcessError as err:
            msg = "Call to ledger failed with: {0}".format(err.output)
            logging.error(msg)
            sys.exit(err.returncode)

        logging.debug("ledger(1) returned: {0}".format(output))
        if len(output) == 0:
            # WARNING: This terminates the run if you gave me a
            # non-credit card with the -c flag.
            logging.info("{0} balance is zero!".format(args.BILL))
            sys.exit()

    msg = "Check if {0} bill was paid"
    logging.info(msg.format("previous"))
    bimonthly = args.zweimon is not None
    isdue = (
            False if bimonthly and (
                (args.zweimon == "e" and date.month % 2 == 1)
                or (args.zweimon == "o" and date.month % 2 == 0)
            ) else True
        )
    logging.debug("Is it due this month? {0}".format(isdue))
    dmonth = 0 
    if args.DAY >= date.day or not isdue:
        dmonth -= 2 if bimonthly and isdue else 1

    dueon = date.replace(day=args.DAY) \
            + dateutil.relativedelta.relativedelta(months=dmonth)
    billdir = os.path.join(
            args.billdir, dueon.strftime("%Y"), dueon.strftime("%m"),
        )
    if not os.path.isdir(billdir):
        logging.warning("Cannot find {0} directory!".format(billdir))
    else:
        tgt = os.path.join(billdir, args.BILL + ".pdf")
        logging.debug("Checking for: {0}".format(tgt))
        if not os.path.isfile(tgt):
            print("{0} is over due!".format(args.BILL))
        else:
            logging.info("Paid!")

    logging.info(msg.format("next"))
    dmonth = 0 
    if args.DAY < date.day or not isdue:
        dmonth += 2 if bimonthly and isdue else 1

    dueon = date.replace(day=args.DAY) \
            + dateutil.relativedelta.relativedelta(months=dmonth)
    noteon = dueon - dateutil.relativedelta.relativedelta(
            days=args.offset
        )
    logging.debug("Notification date: {0}".format(noteon))
    if date >= noteon:
        billdir = os.path.join(
                args.billdir, dueon.strftime("%Y"), 
                dueon.strftime("%m")
            )
        if not os.path.isdir(billdir):
            logging.warning("Cannot find {0} directory!".format(billdir))
        else:
            tgt = os.path.join(billdir, args.BILL + ".pdf")
            logging.debug("Checking for: {0}".format(tgt))
            if not os.path.isfile(tgt):
                print(" ".join(args.msg).format(BILL=args.BILL))
            else:
                logging.info("Paid!")

    sys.exit()

