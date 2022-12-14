// Copyright 2015-2017 Parity Technologies (UK) Ltd.
// This file is part of Parity.

// Parity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Parity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Parity.  If not, see <http://www.gnu.org/licenses/>.

#pragma once

#include <stdint.h>

// rust ffi

const char *rust_createLocalDid(const char *to, const char *filename);
const char *rust_getVerifiableCredentials(const char *filename);
const char *rust_getLocalDid(const char *filename);
const char *rust_deleteVerifiableCredential(const char *id, const char *filename);
const char *rust_verifyVC(const char *vc, const char *signature);
const char *rust_parseVC(const char *vc);
const char *rust_signVC(const char *vc, const char *filename);
const char *rust_parseJWT(const char *jwt);
const char *rust_saveVerifiableCredential(const char *vc, const char *type, const char 
*filename);
const char *rust_signAcceptanceJWT(const char *vc, const char *destination_did, const char 
*filename);
const char *rust_signSharedJWT(const char *vc, const char *destination_did, const char 
*filename);
const char *rust_respondToServer(const char *url, const char *payload);
const char *rust_CryptDataExt(const char *key, const char *data);
const char *rust_DecryptDataExt(const char *key, const char *data);
const char *rust_DeriveSharedKey(const char *key, const char *pkey);
const char *rust_createSharedKeyPair();

void rust_free_string(char *);

