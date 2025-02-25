#!/bin/bash

# Copyright 2020 Adap GmbH. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

set -e
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

ROOT=`pwd`

# Build and deploy Flower Framework docs
cd doc
./build-versioned-docs.sh
cd build/html
aws s3 sync --delete --exclude ".*" --exclude "v/*" --acl public-read --cache-control "no-cache" ./ s3://flower.dev/docs/framework

# Build and deploy Flower Baselines docs
cd $ROOT
cd baselines/doc
make docs
cd build/html
aws s3 sync --delete --exclude ".*" --exclude "v/*" --acl public-read --cache-control "no-cache" ./ s3://flower.dev/docs/baselines

# Build and deploy Flower Examples docs
cd $ROOT
./dev/update-examples.sh
cd examples/doc
make docs
cd build/html
aws s3 sync --delete --exclude ".*" --exclude "v/*" --acl public-read --cache-control "no-cache" ./ s3://flower.dev/docs/examples
