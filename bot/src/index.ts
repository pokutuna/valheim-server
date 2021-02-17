import type {HttpFunction} from '@google-cloud/functions-framework/build/src/functions';
import '@google-cloud/functions-framework/build/src/invoker'; // for rawBody
import type {Request, Response} from 'express'; // eslint-disable-line node/no-extraneous-import

import * as nacl from 'tweetnacl';

const APP_PUBLIC_KEY =
  '2600c865e85f91f97799f52447dd826fc6a8b49cacc7e438649c987d6aeafc45';

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

  return res.send(200);
};

// Security and Authorization
// https://discord.com/developers/docs/interactions/slash-commands#security-and-authorization
function verify(req: Request) {
  const signature = req.header('X-Signature-Ed25519') || '';
  const timestamp = req.header('X-Signature-Timestamp') || '';

  return nacl.sign.detached.verify(
    Buffer.from(timestamp + req.rawBody),
    Buffer.from(signature, 'hex'),
    Buffer.from(APP_PUBLIC_KEY, 'hex')
  );
}
