from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Optional

try:
    import keyring  # type: ignore
except ModuleNotFoundError:  # pragma: no cover
    keyring = None


def _normalize_base_url(base_url: str) -> str:
    return base_url.rstrip("/")


def _service_name(base_url: str, client: str) -> str:
    return f"abap_artifacts::{_normalize_base_url(base_url)}::client::{client}"


@dataclass(frozen=True)
class Credentials:
    base_url: str
    client: str
    user: str
    password: str


def load_credentials(
    *,
    base_url: Optional[str] = None,
    client: Optional[str] = None,
    user: Optional[str] = None,
    password: Optional[str] = None,
    allow_keyring: bool = True,
) -> Credentials:
    resolved_base_url = base_url or os.getenv("ABAP_BASE_URL", "")
    resolved_client = client or os.getenv("ABAP_CLIENT", "")
    resolved_user = user or os.getenv("ABAP_USER", "")
    resolved_password = password or os.getenv("ABAP_PASSWORD", "")

    if not resolved_base_url:
        raise ValueError("Missing base URL (set ABAP_BASE_URL or pass --base-url)")
    if not resolved_client:
        raise ValueError("Missing client (set ABAP_CLIENT or pass --client)")
    if not resolved_user:
        raise ValueError("Missing user (set ABAP_USER or pass --user)")

    if not resolved_password and allow_keyring:
        if keyring is not None:
            stored = keyring.get_password(_service_name(resolved_base_url, resolved_client), resolved_user)
            if stored:
                resolved_password = stored

    if not resolved_password:
        raise ValueError("Missing password (set ABAP_PASSWORD or store via keyring)")

    return Credentials(
        base_url=_normalize_base_url(resolved_base_url),
        client=resolved_client,
        user=resolved_user,
        password=resolved_password,
    )


def set_password(*, base_url: str, client: str, user: str, password: str) -> None:
    if keyring is None:
        raise RuntimeError("keyring is not installed; install it or use env var ABAP_PASSWORD")
    keyring.set_password(_service_name(base_url, client), user, password)


def delete_password(*, base_url: str, client: str, user: str) -> None:
    if keyring is None:
        raise RuntimeError("keyring is not installed; install it to manage stored passwords")
    keyring.delete_password(_service_name(base_url, client), user)
