from __future__ import annotations

from dataclasses import dataclass
from typing import Optional
from urllib.parse import urlencode

from .auth import Credentials
from .http import FetchResult, fetch_text


@dataclass(frozen=True)
class AdtConfig:
    base_url: str
    client: str
    version: str = "active"


def _adt_url(base_url: str, path: str, *, query: dict[str, str]) -> str:
    return f"{base_url}{path}?{urlencode(query)}"


def fetch_bdef_source(
    *,
    bdef_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    # ADT path format is case-insensitive in many systems; keep caller's casing.
    path = f"/sap/bc/adt/bo/behaviordefinitions/{bdef_name}/source/main"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_ddl_source(
    *,
    ddl_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/ddic/ddl/sources/{ddl_name}/source/main"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_table_source(
    *,
    table_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/ddic/tables/{table_name}/source/main"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_structure_source(
    *,
    structure_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/ddic/structures/{structure_name}/source/main"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_data_element_source(
    *,
    element_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/ddic/dataelements/{element_name}"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_domain_source(
    *,
    domain_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/ddic/domains/{domain_name}"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_class_source(
    *,
    class_name: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/oo/classes/{class_name}/source/main"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")


def fetch_class_include(
    *,
    class_name: str,
    include_kind: str,
    creds: Credentials,
    client: Optional[str] = None,
    version: str = "active",
    verify_tls: bool = True,
) -> FetchResult:
    effective_client = client or creds.client
    path = f"/sap/bc/adt/oo/classes/{class_name}/includes/{include_kind}"
    url = _adt_url(creds.base_url, path, query={"version": version, "sap-client": effective_client})
    return fetch_text(url=url, creds=creds, verify_tls=verify_tls, accept="text/plain, */*;q=0.1")
