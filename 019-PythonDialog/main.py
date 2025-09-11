from urllib.parse import urlparse
from textual.app import App
from textual.app import ComposeResult
from textual.widgets import Input, Static
from textual.containers import Vertical
from textual.reactive import reactive
from textual import events

def suggested_icon_from_url(url: str) -> str:
    url = url.strip()
    if not url:
        return "🌐"
    # Lägg till https:// om saknas så parsningen lyckas
    if "://" not in url:
        url = "https://" + url
    try:
        p = urlparse(url)
        if p.scheme and p.netloc:
            return f"{p.scheme}://{p.netloc}/favicon.ico"
    except Exception:
        pass
    return "🌐"

class FormApp(App):
    CSS = """
    Screen {
        align: center middle;
    }
    .label {
        color: yellow;
        text-style: bold;
    }
    .hint {
        color: green;
    }
    .status {
        dock: bottom;
        padding: 1 2;
        background: #202020;
        color: #c0ffc0;
    }
    Input:focus {
        border: tall #888888;
    }
    .box {
        width: 80;
        padding: 1 2;
        border: round #666666;
    }
    """

    BINDINGS = [
        ("escape", "quit", "Avsluta"),
        ("enter", "submit", "Skicka"),
        ("tab", "next_field", "Nästa fält"),
        ("shift+tab", "prev_field", "Föregående fält"),
        ("up", "prev_field", "Föregående fält"),
        ("down", "next_field", "Nästa fält"),
    ]

    focus_index = reactive(0)

    def compose(self) -> ComposeResult:
        yield Vertical(
            Static("NAMN", classes="label"),
            Input(placeholder="Ange namn...", id="name"),
            Static("URL", classes="label"),
            Input(placeholder="https://exempel.se", id="url"),
            Static("IKON", classes="label"),
            Input(placeholder="Föreslås från URL eller 🌐", id="icon"),
            Static("Tab/Shift+Tab eller ↑/↓ byter fält • Enter skickar • Esc lämnar", classes="hint"),
            classes="box",
        )
        yield Static("", id="status", classes="status")

    def on_mount(self) -> None:
        self.inputs = [self.query_one("#name", Input),
                       self.query_one("#url", Input),
                       self.query_one("#icon", Input)]
        self.set_focus(self.inputs[self.focus_index])

    # Uppdatera IKON-fältets placeholder/suggestion när URL ändras
    def on_input_changed(self, event: Input.Changed) -> None:
        if event.input.id == "url":
            icon_input = self.query_one("#icon", Input)
            suggestion = suggested_icon_from_url(event.value)
            # Om användaren inte redan har matat något i IKON, uppdatera
            if not icon_input.value:
                icon_input.placeholder = suggestion

    def action_next_field(self) -> None:
        self.focus_index = (self.focus_index + 1) % len(self.inputs)
        self.set_focus(self.inputs[self.focus_index])

    def action_prev_field(self) -> None:
        self.focus_index = (self.focus_index - 1) % len(self.inputs)
        self.set_focus(self.inputs[self.focus_index])

    def action_submit(self) -> None:
        name = self.query_one("#name", Input).value.strip()
        url  = self.query_one("#url", Input).value.strip()
        icon_widget = self.query_one("#icon", Input)
        icon = icon_widget.value.strip() or icon_widget.placeholder or "🌐"

        # Fyll på defaultförslag ifall användaren bara trycker Enter
        if not icon.strip():
            icon = suggested_icon_from_url(url)

        msg = f"Skickat:\n  NAMN: {name or '(tomt)'}\n  URL: {url or '(tomt)'}\n  IKON: {icon}"
        self.query_one("#status", Static).update(msg)

    async def on_key(self, event: events.Key) -> None:
        # För att Enter ska trigga även när fokus är i ett Input
        if event.key == "enter":
            self.action_submit()
        elif event.key == "escape":
            await self.action_quit()

if __name__ == "__main__":
    FormApp().run()
