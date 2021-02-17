import type {HttpFunction} from '@google-cloud/functions-framework/build/src/functions';

export const app: HttpFunction = (req, res) => {
  console.log(req.body);
  res.send(200);
};
