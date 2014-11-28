#!/usr/bin/env python
__info__="""
A collection of tools to manage passwords for email.

"""
import keyring

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__info__)
    subparser = parser.add_subparsers(
            title="Commands", help="Action to perform"
        )
    gparser = subparser.add_parser(
            "get", help="Interface to ``keyring.get_password``"
        )
    gparser.add_argument("service", help="The service to check")
    gparser.add_argument("account", help="The account to check")
    def get(args):
        """Call ``keyring.get_pasword``"""
        password = keyring.get_password(args.service, args.account)
        if password:
            print(password)
        return
    gparser.set_defaults(func=get)
    #
    sparser = subparser.add_parser(
            "set", help="Interface to ``keyring.set_password``"
        )
    sparser.add_argument("service", help="The service to update")
    sparser.add_argument("account", help="The account to update")
    sparser.add_argument("password", help="The new password")
    def set(args):
        """Call ``keyring.set_pasword``"""
        keyring.set_password(args.service, args.account, args.password)
        return
    sparser.set_defaults(func=set)
    #
    dparser = subparser.add_parser(
            "del", help="Interface to ``keyring.delete_password```"
        )
    dparser.add_argument("service", help="The service to delete")
    dparser.add_argument("account", help="The account to delete")
    def delete(args):
        """Call ``keyring.delete_password``"""
        keyring.delete_password(args.service, args.account)
        return
    dparser.set_defaults(func=delete)
    args = parser.parse_args()
    args.func(args)

