# Google AI Edge Gallery skills

[Agent Skills](https://github.com/google-ai-edge/gallery/blob/main/skills/README.md)
for the [Google AI Edge Gallery](https://github.com/google-ai-edge/gallery)
app. They let an on-device model hand time to the Time Logger Android app
through its `timelogger://` deep links (see
[Android Intents](../README.md#android-intents)).

| Skill | Type | What it does |
|-------|------|--------------|
| [log-time](log-time) | JS | Turns "I spent 90 minutes on code review for acme" into a link that opens the pre-filled entry editor, or "start a timer for the standup" into one that pre-fills the timer. Also links to entries and reports. |
| [time-reminder](time-reminder) | Native | Schedules a one-off or daily notification that opens the entry editor or timer, optionally pre-filled. |

Gallery cannot open other apps on its own: custom native intents need changes
to Gallery itself, and its webviews do not follow custom URL schemes. Instead,
`log-time` replies with a markdown link that you tap, and `time-reminder` uses
the built-in `schedule_notification` intent, whose `deeplink` is opened when
the notification is tapped. Time is recorded in the Time Logger app when you
tap **Start** or **Save**, never by the skill.

## Installing

Push a skill folder to the device and import it in Gallery:

```sh
adb push google-ai-edge-gallery-skills/log-time /sdcard/Download/
adb push google-ai-edge-gallery-skills/time-reminder /sdcard/Download/
```

In Gallery, open **Agent Skills** with a model, tap the **Skills** chip, tap
**(+)**, choose **Import local skill** and select the skill folder.

To load a skill from a URL instead, host this directory on a web host such as
GitHub Pages (with an empty `.nojekyll` file at the root). Raw GitHub URLs
serve files as `text/plain`, which breaks JS skills.

## Testing

The link built by `log-time` can be checked in a desktop browser by opening
`log-time/scripts/index.html` and running in the console:

```js
await window.ai_edge_gallery_get_result(JSON.stringify({
  mode: "entry", description: "Code review", project: "acme", tags: ["Billable"],
  duration: "1h30m", date: "2026-10-16",
}))
// {"result":"timelogger://entry/new?description=Code%20review&project=acme&tags=billable&date=2026-10-16&duration=90"}
```

Then open the link on a device with the app installed:

```sh
# quote the whole command so the device shell does not treat & as a separator
adb shell "am start -a android.intent.action.VIEW \
  -d 'timelogger://entry/new?description=Code%20review&project=acme&tags=billable&date=2026-10-16&duration=90'"
```

In Gallery, expand the skill execution panel to see the data passed to the
script and its console logs.
