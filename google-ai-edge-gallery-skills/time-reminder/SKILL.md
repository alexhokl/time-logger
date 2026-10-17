---
name: time-reminder
description: Schedule a reminder notification that opens the Time Logger app when tapped. Use this when the user wants to be reminded to log or record their time, or to start a timer for something at a later time, such as a meeting.
metadata:
  homepage: https://github.com/alexhokl/time-logger/tree/main/google-ai-edge-gallery-skills/time-reminder
---

# Time reminder

## Instructions

To schedule a time reminder, you must follow these exact steps:

1. If the reminder does not repeat daily, call the `run_intent` tool with
   `intent` as `get_current_date_and_time` and `parameters` as `{}` to get the
   user's local date and time. Then explicitly calculate the date of the
   reminder, rolling over to the next month or year if needed.
2. Build the deep link that opens the app:
   - To log time already spent (e.g. "remind me to log my time"), start with
     `timelogger://entry/new`.
   - To start a timer (e.g. "remind me to start the standup timer"), start
     with `timelogger://timer`.
   - If the user mentioned what the work is, add query parameters after `?`,
     joined with `&`:
     - `description`: the work, e.g. `Standup`.
     - `project`: the project name, e.g. `acme`.
     - `tags`: comma-separated tags, e.g. `meetings`.
   - Replace every space in a value with `%20` and every `&` with `%26`.
3. Call the `run_intent` tool with the following exact parameters:
   - intent: schedule_notification
   - parameters: A JSON string with the following fields:
     - title: the title of the notification, e.g. "Log your time". String.
     - message: the message of the notification, e.g. "Record what you worked on today". String.
     - hour: the hour of the day (0-23). Integer.
     - minute: the minute of the hour (0-59). Integer.
     - deeplink: the deep link from step 2. String.
     - year: (optional) the year of the reminder. Integer.
     - month: (optional) the month (1-12) of the reminder. Integer.
     - day: (optional) the day of the month (1-31) of the reminder. Integer.
     - repeat_daily: (optional) true if the reminder repeats every day. Boolean.
4. Tell the user when the reminder will appear and that tapping it opens the
   app with the form filled in. Nothing is recorded until they tap Start or
   Save.

Reminders can only repeat daily. If the user asks for a weekly or monthly
reminder, schedule the next occurrence only and tell the user.

### Examples

- "Remind me every day at 6pm to log my time":

  ```json
  {"title": "Log your time", "message": "Record what you worked on today", "hour": 18, "minute": 0, "deeplink": "timelogger://entry/new", "repeat_daily": true}
  ```

- "Remind me tomorrow at 9:30 to start the standup timer for acme":

  ```json
  {"title": "Standup", "message": "Start the standup timer", "hour": 9, "minute": 30, "year": 2026, "month": 10, "day": 18, "deeplink": "timelogger://timer?description=Standup&project=acme"}
  ```
