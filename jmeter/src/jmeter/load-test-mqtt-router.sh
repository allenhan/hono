#!/bin/bash
#*******************************************************************************
# Copyright (c) 2016, 2018 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0
#
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************
# Execution Example
# ./load-test-mqtt-router.sh /home/hono/apache-jmeter-5.1.1 registry.hono.yourdomain.com router.hono.yourdomain.com mqtt.hono.yourdomain.com 10 2
#*******************************************************************************
SCRIPTPATH="$(cd "$(dirname "$0")" && pwd -P)"
JMETER_HOME=${1:-~/apache-jmeter-5.1.1}
REGISTRATION_HOST=${2:-127.0.0.1}
ROUTER_HOST=${3:-127.0.0.1}
MQTT_ADAPTER_HOST=${4:-127.0.0.1}
HONO_HOME=${HONO_HOME:=$SCRIPTPATH/../../..}
SAMPLE_LOG=load-test-mqtt-router.jtl
TEST_LOG=load-test-mqtt-router.log
DEVICE_COUNT=${5:-10}
CONSUMER_COUNT=${6:-2}

rm -f $SAMPLE_LOG

$JMETER_HOME/bin/jmeter -n -f -l $SAMPLE_LOG -j $TEST_LOG \
-t $SCRIPTPATH/mqtt_messaging_throughput_test.jmx \
-Jplugin_dependency_paths=$HONO_HOME/jmeter/target/plugin \
-Jjmeterengine.stopfail.system.exit=true \
-Jrouter.host=$ROUTER_HOST -Jrouter.port=15672 \
-Jregistration.host=$REGISTRATION_HOST -Jregistration.port=28080 \
-Jmqtt.host=$MQTT_ADAPTER_HOST -Jmqtt.port=1883 \
-Lorg.eclipse.hono.client.impl=INFO -Lorg.eclipse.hono.jmeter=INFO \
-JdeviceCount=$DEVICE_COUNT -JconsumerCount=$CONSUMER_COUNT
