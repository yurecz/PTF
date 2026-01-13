from __future__ import annotations

import os
import traceback
from typing import Any, Optional
from urllib.parse import urlparse

from abap_artifacts.adt import (
    fetch_bdef_source,
    fetch_class_include,
    fetch_class_source,
    fetch_data_element_source,
    fetch_ddl_source,
    fetch_domain_source,
    fetch_structure_source,
    fetch_table_source,
)
from abap_artifacts.auth import load_credentials
from abap_artifacts.docu import fetch_keyword_docu
from abap_artifacts.http import fetch_text

from .jsonrpc import jsonrpc_error, jsonrpc_result, read_message, write_response


SERVER_INFO = {"name": "abap-artifacts-mcp", "version": "0.1.0"}


def _configure_keyring_backend() -> None:
    backend = os.getenv("ABAP_KEYRING_BACKEND")
    if backend and not os.getenv("PYTHON_KEYRING_BACKEND"):
        os.environ["PYTHON_KEYRING_BACKEND"] = backend


def _env_default(name: str) -> Optional[str]:
    value = os.getenv(name)
    return value if value else None


def _env_flag(name: str) -> Optional[bool]:
    value = os.getenv(name)
    if not value:
        return None
    lowered = value.strip().lower()
    if lowered in {"1", "true", "yes", "on"}:
        return True
    if lowered in {"0", "false", "no", "off"}:
        return False
    return None


def _resolve_insecure(args: dict[str, Any]) -> bool:
    if "insecure" in args:
        return bool(args.get("insecure", False))
    env_insecure = _env_flag("ABAP_INSECURE")
    return bool(env_insecure) if env_insecure is not None else False


def _tool_schema() -> list[dict[str, Any]]:
    return [
        {
            "name": "abap.fetchDocu",
            "description": "Fetch ABAP Keyword Documentation page by object id (no auth).",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "baseUrl": {"type": "string", "default": "https://ldciemo.wdf.sap.corp:44300"},
                    "object": {"type": "string"},
                    "lang": {"type": "string", "default": "EN"},
                    "client": {"type": "string", "default": "000"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["object"],
            },
        },
        {
            "name": "abap.fetchUrl",
            "description": "Fetch a URL; optionally uses basic auth from env/keyring (same-origin only).",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "url": {"type": "string"},
                    "auth": {"type": "boolean", "default": False},
                    "baseUrl": {"type": "string", "description": "If auth=true, base URL for credential scoping; defaults to URL origin."},
                    "client": {"type": "string"},
                    "user": {"type": "string"},
                    "insecure": {"type": "boolean", "default": False},
                    "accept": {"type": "string"},
                },
                "required": ["url"],
            },
        },
        {
            "name": "abap.fetchBdef",
            "description": "Fetch BDEF source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchCds",
            "description": "Fetch CDS DDL source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchTable",
            "description": "Fetch DDIC table source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchStructure",
            "description": "Fetch DDIC structure source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchDataElement",
            "description": "Fetch DDIC data element source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchDomain",
            "description": "Fetch DDIC domain source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchClass",
            "description": "Fetch ABAP class main source via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name"],
            },
        },
        {
            "name": "abap.fetchClassInclude",
            "description": "Fetch ABAP class include (definitions/implementations/testclasses/macros) via ADT.",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "include": {"type": "string", "enum": ["definitions", "implementations", "testclasses", "macros"]},
                    "client": {"type": "string"},
                    "version": {"type": "string", "enum": ["active", "inactive"], "default": "active"},
                    "insecure": {"type": "boolean", "default": False},
                },
                "required": ["name", "include"],
            },
        },
    ]


def _content_text(text: str) -> dict[str, Any]:
    # MCP "content" format used by many clients
    return {"content": [{"type": "text", "text": text}]}


def _handle_tool_call(name: str, args: dict[str, Any]) -> dict[str, Any]:
    insecure = _resolve_insecure(args)
    verify_tls = not insecure

    if name == "abap.fetchDocu":
        base_url = args.get("baseUrl") or _env_default("ABAP_BASE_URL") or "https://ldciemo.wdf.sap.corp:44300"
        client = args.get("client") or _env_default("ABAP_CLIENT") or "000"
        res = fetch_keyword_docu(
            base_url=base_url,
            object_id=args["object"],
            lang=args.get("lang", "EN"),
            client=client,
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchUrl":
        url = args["url"]
        use_auth = bool(args.get("auth", False))
        accept = args.get("accept") or "text/plain, text/html;q=0.9, */*;q=0.1"

        creds = None
        if use_auth:
            parsed = urlparse(url)
            default_base = f"{parsed.scheme}://{parsed.netloc}"
            client = args.get("client") or _env_default("ABAP_CLIENT")
            user = args.get("user") or _env_default("ABAP_USER")
            creds = load_credentials(
                base_url=args.get("baseUrl") or _env_default("ABAP_BASE_URL") or default_base,
                client=client,
                user=user,
                password=None,
                allow_keyring=True,
            )

        res = fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept=accept)
        return _content_text(res.text)

    if name == "abap.fetchBdef":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_bdef_source(
            bdef_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchCds":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_ddl_source(
            ddl_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchClass":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_class_source(
            class_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchTable":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_table_source(
            table_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchStructure":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_structure_source(
            structure_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchDataElement":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_data_element_source(
            element_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchDomain":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_domain_source(
            domain_name=args["name"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    if name == "abap.fetchClassInclude":
        client = args.get("client") or _env_default("ABAP_CLIENT")
        creds = load_credentials(
            base_url=_env_default("ABAP_BASE_URL"),
            client=client,
            user=_env_default("ABAP_USER"),
            allow_keyring=True,
        )
        res = fetch_class_include(
            class_name=args["name"],
            include_kind=args["include"],
            creds=creds,
            client=client,
            version=args.get("version", "active"),
            verify_tls=verify_tls,
        )
        return _content_text(res.text)

    raise ValueError(f"Unknown tool: {name}")


def run() -> None:
    _configure_keyring_backend()
    initialized = False
    while True:
        msg = read_message()
        if msg is None:
            return

        id_ = msg.get("id")
        method = msg.get("method")
        params: dict[str, Any] = msg.get("params") or {}

        try:
            if method == "initialize":
                initialized = True
                protocol_version = params.get("protocolVersion") or "2024-11-05"
                if id_ is not None:
                    write_response(
                        jsonrpc_result(
                            id=id_,
                            result={
                                "protocolVersion": protocol_version,
                                "serverInfo": SERVER_INFO,
                                "capabilities": {"tools": {"listChanged": False}},
                            },
                        )
                    )
            elif method == "initialized":
                # "initialized" is a notification; no response.
                pass
            elif method in ("resources/list", "listResources"):
                if id_ is not None:
                    write_response(jsonrpc_result(id=id_, result={"resources": []}))
            elif method in ("resources/templates/list", "listResourceTemplates"):
                if id_ is not None:
                    write_response(jsonrpc_result(id=id_, result={"resourceTemplates": []}))
            elif method in ("tools/list", "listTools"):
                if id_ is not None:
                    if not initialized:
                        write_response(jsonrpc_error(id=id_, code=-32002, message="Not initialized"))
                    else:
                        write_response(jsonrpc_result(id=id_, result={"tools": _tool_schema()}))
            elif method in ("tools/call", "callTool"):
                if id_ is not None:
                    if not initialized:
                        write_response(jsonrpc_error(id=id_, code=-32002, message="Not initialized"))
                    else:
                        tool_name = params.get("name")
                        tool_args = params.get("arguments") or {}
                        if not tool_name:
                            write_response(jsonrpc_error(id=id_, code=-32602, message="Missing tool name"))
                        else:
                            result = _handle_tool_call(tool_name, tool_args)
                            write_response(jsonrpc_result(id=id_, result=result))
            else:
                if id_ is not None:
                    write_response(jsonrpc_error(id=id_, code=-32601, message=f"Method not found: {method}"))
        except Exception as exc:  # noqa: BLE001
            # Do not include credentials; just a sanitized stack.
            if id_ is not None:
                write_response(
                    jsonrpc_error(
                        id=id_,
                        code=-32000,
                        message=str(exc),
                        data={"trace": traceback.format_exc(limit=5)},
                    )
                )
