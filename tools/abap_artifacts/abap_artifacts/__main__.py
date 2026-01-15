from __future__ import annotations

import argparse
import getpass
import json
import sys
from urllib.parse import urlparse

from .adt import (
    fetch_bdef_source,
    fetch_class_include,
    fetch_class_source,
    fetch_data_element_source,
    fetch_ddl_source,
    fetch_domain_source,
    fetch_interface_source,
    fetch_structure_source,
    fetch_table_source,
)
from .auth import delete_password, load_credentials, set_password
from .docu import fetch_keyword_docu
from .http import fetch_text


def _add_common_auth_args(p: argparse.ArgumentParser) -> None:
    p.add_argument("--base-url", default=None, help="Base URL, e.g. https://host:port (or env ABAP_BASE_URL)")
    p.add_argument("--client", default=None, help="Client, e.g. 030 (or env ABAP_CLIENT)")
    p.add_argument("--user", default=None, help="User (or env ABAP_USER)")
    p.add_argument("--password", default=None, help="Password (or env ABAP_PASSWORD; omitted uses keyring)")
    p.add_argument("--no-keyring", action="store_true", help="Do not read password from OS keyring")
    p.add_argument("--insecure", action="store_true", help="Disable TLS verification (not recommended)")


def cmd_auth_set_password(args: argparse.Namespace) -> int:
    password = args.password or getpass.getpass("ABAP password: ")
    set_password(base_url=args.base_url, client=args.client, user=args.user, password=password)
    return 0


def cmd_auth_delete_password(args: argparse.Namespace) -> int:
    delete_password(base_url=args.base_url, client=args.client, user=args.user)
    return 0


def cmd_fetch_url(args: argparse.Namespace) -> int:
    verify_tls = not args.insecure
    url = args.url

    creds = None
    if args.auth:
        base_url = args.base_url or f"{urlparse(url).scheme}://{urlparse(url).netloc}"
        creds = load_credentials(
            base_url=base_url,
            client=args.client,
            user=args.user,
            password=args.password,
            allow_keyring=not args.no_keyring,
        )

    res = fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept=args.accept)
    if args.json:
        print(json.dumps(res.__dict__, ensure_ascii=False))
    else:
        sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_bdef(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_bdef_source(
        bdef_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_ddl(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_ddl_source(
        ddl_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_table(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_table_source(
        table_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_structure(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_structure_source(
        structure_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_data_element(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_data_element_source(
        element_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_domain(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_domain_source(
        domain_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_class(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_class_source(
        class_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_interface(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_interface_source(
        interface_name=args.name,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_class_include(args: argparse.Namespace) -> int:
    creds = load_credentials(
        base_url=args.base_url,
        client=args.client,
        user=args.user,
        password=args.password,
        allow_keyring=not args.no_keyring,
    )
    res = fetch_class_include(
        class_name=args.name,
        include_kind=args.include,
        creds=creds,
        client=args.client,
        version=args.version,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def cmd_fetch_docu(args: argparse.Namespace) -> int:
    res = fetch_keyword_docu(
        base_url=args.base_url,
        object_id=args.object,
        lang=args.lang,
        client=args.client,
        verify_tls=not args.insecure,
    )
    sys.stdout.write(res.text)
    return 0 if res.status_code < 400 else 2


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="abap_artifacts", add_help=True)
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_auth = sub.add_parser("auth", help="Manage credentials in OS keyring")
    sub_auth = p_auth.add_subparsers(dest="auth_cmd", required=True)
    p_set = sub_auth.add_parser("set-password", help="Store password in keyring")
    p_set.add_argument("--base-url", required=True)
    p_set.add_argument("--client", required=True)
    p_set.add_argument("--user", required=True)
    p_set.add_argument("--password", default=None, help="If omitted, prompts")
    p_set.set_defaults(func=cmd_auth_set_password)
    p_del = sub_auth.add_parser("delete-password", help="Delete password from keyring")
    p_del.add_argument("--base-url", required=True)
    p_del.add_argument("--client", required=True)
    p_del.add_argument("--user", required=True)
    p_del.set_defaults(func=cmd_auth_delete_password)

    p_url = sub.add_parser("fetch-url", help="Fetch any URL (optionally with basic auth)")
    p_url.add_argument("url")
    p_url.add_argument("--accept", default="text/plain, text/html;q=0.9, */*;q=0.1")
    p_url.add_argument("--auth", action="store_true", help="Send basic auth (credentials from env/keyring)")
    p_url.add_argument("--json", action="store_true", help="Output JSON wrapper (status, content-type, text)")
    _add_common_auth_args(p_url)
    p_url.set_defaults(func=cmd_fetch_url)

    p_bdef = sub.add_parser("fetch-bdef", help="Fetch BDEF source via ADT")
    p_bdef.add_argument("name", help="Behavior definition name (ADT id)")
    p_bdef.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_bdef)
    p_bdef.set_defaults(func=cmd_fetch_bdef)

    p_ddl = sub.add_parser("fetch-ddl", help="Fetch CDS DDL source via ADT")
    p_ddl.add_argument("name", help="DDL source name (ADT id), e.g. c_foo")
    p_ddl.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_ddl)
    p_ddl.set_defaults(func=cmd_fetch_ddl)

    p_table = sub.add_parser("fetch-table", help="Fetch DDIC table source via ADT")
    p_table.add_argument("name", help="Table name (ADT id), e.g. sflight")
    p_table.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_table)
    p_table.set_defaults(func=cmd_fetch_table)

    p_structure = sub.add_parser("fetch-structure", help="Fetch DDIC structure source via ADT")
    p_structure.add_argument("name", help="Structure name (ADT id), e.g. bapiaddr1")
    p_structure.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_structure)
    p_structure.set_defaults(func=cmd_fetch_structure)

    p_data = sub.add_parser("fetch-data-element", help="Fetch DDIC data element source via ADT")
    p_data.add_argument("name", help="Data element name (ADT id), e.g. bukrs")
    p_data.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_data)
    p_data.set_defaults(func=cmd_fetch_data_element)

    p_domain = sub.add_parser("fetch-domain", help="Fetch DDIC domain source via ADT")
    p_domain.add_argument("name", help="Domain name (ADT id), e.g. bukrs")
    p_domain.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_domain)
    p_domain.set_defaults(func=cmd_fetch_domain)

    p_class = sub.add_parser("fetch-class", help="Fetch ABAP class main source via ADT")
    p_class.add_argument("name", help="Class name (ADT id), e.g. cl_foo")
    p_class.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_class)
    p_class.set_defaults(func=cmd_fetch_class)

    p_interface = sub.add_parser("fetch-interface", help="Fetch ABAP interface main source via ADT")
    p_interface.add_argument("name", help="Interface name (ADT id), e.g. if_foo")
    p_interface.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_interface)
    p_interface.set_defaults(func=cmd_fetch_interface)

    p_class_inc = sub.add_parser("fetch-class-include", help="Fetch ABAP class include via ADT")
    p_class_inc.add_argument("name", help="Class name (ADT id), e.g. cl_foo")
    p_class_inc.add_argument(
        "--include",
        required=True,
        choices=["definitions", "implementations", "testclasses", "macros"],
        help="Include kind",
    )
    p_class_inc.add_argument("--version", default="active", choices=["active", "inactive"])
    _add_common_auth_args(p_class_inc)
    p_class_inc.set_defaults(func=cmd_fetch_class_include)

    p_docu = sub.add_parser("fetch-docu", help="Fetch ABAP keyword docu page by object id (no auth)")
    p_docu.add_argument("object", help="Keyword docu object id, e.g. ABENEML")
    p_docu.add_argument("--base-url", default="https://ldciemo.wdf.sap.corp:44300")
    p_docu.add_argument("--lang", default="EN")
    p_docu.add_argument("--client", default="000")
    p_docu.add_argument("--insecure", action="store_true", help="Disable TLS verification (not recommended)")
    p_docu.set_defaults(func=cmd_fetch_docu)

    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())
