/*
 * Copyright (c) 2018-2019 Cloudera, Inc. All rights reserved.
 *
 * This code is provided to you pursuant to your written agreement with Cloudera, which may be the terms of the
 * Affero General Public License version 3 (AGPLv3), or pursuant to a written agreement with a third party authorized
 * to distribute this code.  If you do not have a written agreement with Cloudera or with an authorized and
 * properly licensed third party, you do not have any rights to this code.
 *
 * If this code is provided to you under the terms of the AGPLv3:
 *  (A) CLOUDERA PROVIDES THIS CODE TO YOU WITHOUT WARRANTIES OF ANY KIND;
 *  (B) CLOUDERA DISCLAIMS ANY AND ALL EXPRESS AND IMPLIED WARRANTIES WITH RESPECT TO THIS CODE, INCLUDING BUT NOT
 *      LIMITED TO IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE;
 *  (C) CLOUDERA IS NOT LIABLE TO YOU, AND WILL NOT DEFEND, INDEMNIFY, OR HOLD YOU HARMLESS FOR ANY CLAIMS ARISING
 *      FROM OR RELATED TO THE CODE; AND
 *  (D) WITH RESPECT TO YOUR EXERCISE OF ANY RIGHTS GRANTED TO YOU FOR THE CODE, CLOUDERA IS NOT LIABLE FOR ANY
 *      DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, PUNITIVE OR CONSEQUENTIAL DAMAGES INCLUDING, BUT NOT LIMITED
 *      TO, DAMAGES RELATED TO LOST REVENUE, LOST PROFITS, LOSS OF INCOME, LOSS OF BUSINESS ADVANTAGE OR
 *      UNAVAILABILITY, OR LOSS OR CORRUPTION OF DATA.
 */
package com.cloudera.cem.efm.service.event;

import com.cloudera.cem.efm.profile.DevProfile;
import com.cloudera.cem.efm.service.BackgroundTaskScheduler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
@DevProfile
public class EventSpawner extends BackgroundTaskScheduler {

    private static final Logger logger = LoggerFactory.getLogger(EventSpawner.class);
    private static final Duration EVENT_SPAWNER_INTERVAL_MILLIS = Duration.ofSeconds(10);

    private final StandardEventService eventService;

    @Autowired
    public EventSpawner(EventSpawnerTask task, StandardEventService eventService) {
        super(task, EVENT_SPAWNER_INTERVAL_MILLIS);
        this.eventService = eventService;
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        // Populate large initial set of events if necessary
        if (eventService.getEvents(null).getPage().getTotalElements() == 0) {
            int randomEventCount = ((StandardEventService)eventService).generateAndSaveRandomEventEntities(200);
            logger.warn("*** GENERATED {} DUMMY EVENTS FOR DEV TESTING *** ", randomEventCount);
        }
        super.onApplicationEvent(event);
    }

}
