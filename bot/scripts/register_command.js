'use strict';

// https://discord.com/developers/docs/interactions/slash-commands#registering-a-command

const util = require('util');
const fetch = require('node-fetch'); // eslint-disable-line node/no-unpublished-require

const CLIENT_ID = process.env.CLIENT_ID;
const BOT_TOKEN = process.env.BOT_TOKEN;

// right-click a server in Disocrd App & select "Copy ID"
const GUILD_ID = process.env.GUILD_ID;

const url = `https://discord.com/api/v8/applications/${CLIENT_ID}/guilds/${GUILD_ID}/commands`;

const payload = {
  name: 'server',
  description: 'Operate server',

  // https://discord.com/developers/docs/interactions/slash-commands#applicationcommandoption
  options: [
    {
      name: 'status',
      description: 'show server info',
      type: 1,
      options: [
        {
          name: 'instance',
          description: 'instance name',
          type: 3,
          required: true,
        },
      ],
    },
    {
      name: 'start',
      description: 'start a server',
      type: 1,
      options: [
        {
          name: 'instance',
          description: 'instance name',
          type: 3,
          required: true,
        },
      ],
    },
    {
      name: 'stop',
      description: 'stop a server',
      type: 1,
      options: [
        {
          name: 'instance',
          description: 'instance name',
          type: 3,
          required: true,
        },
      ],
    },
  ],
};

(async () => {
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bot ${BOT_TOKEN}`,
    },
    body: JSON.stringify(payload),
  }).then(res => res.json());

  console.log(util.inspect(res, {showHidden: false, depth: null}));
})();
