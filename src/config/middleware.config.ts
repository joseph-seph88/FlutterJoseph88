import { Express } from 'express';
import helmet from 'helmet';
import * as morgan from 'morgan';

export function setupMiddlewares(app: Express) {
    app.use(helmet());
    app.use(morgan('dev'));
}
