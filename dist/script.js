let time = 0
let id = null
let adminId = null

function convert(seconds) {
  let minutes = Math.floor(seconds / 60);
  let remainingSeconds = seconds % 60;
  minutes = minutes.toString().padStart(2, '0');
  remainingSeconds = remainingSeconds.toString().padStart(2, '0');
  return `${minutes}:${remainingSeconds}`;
}

window.addEventListener('message', (event) => {
    const TimeHeader = document.getElementById("time");
    const DiscordInvite = document.getElementById("text-invite");
    const HtmlHed = document.documentElement;
    const BodyHed = document.body;
    const data = event.data;
    time = data.time

    if (data.isOpen === true) {
        HtmlHed.style.display = 'flex';
        BodyHed.style.display = 'flex';
        id = data.id
        adminId = data.adminId
          if (data.IsTimmed == true) {
              TimeHeader.innerHTML = convert(data.time)
              DiscordInvite.innerHTML = data.invite
              StartTimer(data.time, TimeHeader);
          } else if (data.IsTimmed != true) {
            TimeHeader.innerHTML = `∞`
          }
    } else if (data.isOpen === false) {
      HtmlHed.style.display = 'none';
      BodyHed.style.display = 'none';
    }
})

function copyText() {
    let text = document.getElementById("text-invite").textContent;

    if (text) {
      fetch(`https://${GetParentResourceName()}/GetInvite`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            invite: text
        })
    })
    }
  }

  const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds));
  }

async function StartTimer(data, header) {
  for( time = data; time >= 0; time--) {
    if (time != 0) {
      header.innerHTML = convert(time)
      await sleep(1000)
    } else if (time === 0) {
      fetch(`https://${GetParentResourceName()}/BanPlayerBecauseTime`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id,
            adminId: adminId
        })
    })
    }
  }
}