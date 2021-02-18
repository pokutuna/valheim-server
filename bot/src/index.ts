import type {HttpFunction} from '@google-cloud/functions-framework/build/src/functions';
import '@google-cloud/functions-framework/build/src/invoker'; // for rawBody
import type {Request, Response} from 'express'; // eslint-disable-line node/no-extraneous-import

import * as nacl from 'tweetnacl';
import {google} from 'googleapis';

const project = process.env.PROJECT_ID;
const zone = process.env.COMPUTE_ENGINE_ZONE;
const APP_PUBLIC_KEY = process.env.APP_PUBLIC_KEY;
const COMMAND_NAME = process.env.COMMAND_NAME;

export const app: HttpFunction = (req: Request, res: Response) => {
  if (process.env.NODE_ENV !== 'production') {
    console.log(req.body);
  }

  if (!verify(req)) return res.status(401).end('invalid request signature');
  if (!req.is('application/json')) return res.send(400);

  // PING PONG
  if (req.body.type === 1) {
    return res.status(200).json({type: 1});
  }

  if (req.body.type === 2 && req.body.data.name === COMMAND_NAME) {
    (async () => {
      const options = req.body.data.options[0];
      const action = options.name;
      const instance = options.options[0].value;
      const message = await operate(action, instance);
      return res.status(200).json({type: 4, data: {content: message}});
    })().catch(err => {
      console.error(err);
      return res.status(200).json({type: 4, data: {content: err.message}});
    });
  } else {
    return res.send(400);
  }
};

// Security and Authorization
// https://discord.com/developers/docs/interactions/slash-commands#security-and-authorization
function verify(req: Request) {
  const signature = req.header('X-Signature-Ed25519') || '';
  const timestamp = req.header('X-Signature-Timestamp') || '';

  return nacl.sign.detached.verify(
    Buffer.from(timestamp + req.rawBody),
    Buffer.from(signature, 'hex'),
    Buffer.from(APP_PUBLIC_KEY || '', 'hex')
  );
}

async function operate(action: string, instance: string): Promise<string> {
  // Using googleapis, @google-cloud/compute doesn't provide ts types
  const googleAuth = new google.auth.GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/compute'],
  });
  const auth = await googleAuth.getClient();

  const params = {
    project,
    zone,
    instance,
    auth,
  };

  switch (action) {
    case 'start': {
      await google.compute('v1').instances.start(params);
      // TODO send follow up message to show new IP
      return 'starting...';
    }
    case 'stop':
      await google.compute('v1').instances.stop(params);
      return 'stopping...';
    case 'status': {
      const res = await google.compute('v1').instances.get(params);
      const address = res.data.networkInterfaces?.[0].accessConfigs?.[0].natIP;
      return `status: ${res.data.status}, address: ${address}:2457`;
    }
    default:
      return '';
  }
}
