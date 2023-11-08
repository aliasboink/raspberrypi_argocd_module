#!/bin/bash

argocd_credentials_key="$(cat ~/.ssh/id_ed25519)"

export TF_VAR_argocd_credentials_key="$argocd_credentials_key"