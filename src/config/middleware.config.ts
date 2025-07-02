import { Express } from 'express';
import helmet from 'helmet';
import * as morgan from 'morgan';


export function setupMiddlewares(app: Express) {
    app.use(helmet({ contentSecurityPolicy: false }));
    app.use(morgan('dev'));
}
