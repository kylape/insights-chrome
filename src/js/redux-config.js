import * as actionTemplates from './redux/actions';
import chromeReducer from './redux';
import {
    ReducerRegistry,
    dispatchActionsToStore,
    MiddlewareListener
} from '@red-hat-insights/insights-frontend-components';

import * as appNav from './nav/appNav.js';
import * as globalNav from './nav/globalNav.js';
import { createReduxListener } from './utils';

const basicMiddlewares = [];
if (process.env.NODE_ENV === 'development') {
    import('redux-logger').then(logger => basicMiddlewares.push(logger.default));
}

// const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

export function spinUpStore(initState = {}, middlewares = []) {
    const middlewareListener = new MiddlewareListener();
    const reduxRegistry = new ReducerRegistry(
        initState,
        [
            middlewareListener.getMiddleware(),
            ...basicMiddlewares,
            ...middlewares
        ]
    );

    reduxRegistry.register(chromeReducer());
    const store = reduxRegistry.getStore();

    store.subscribe(createReduxListener(store, 'chrome.globalNav', globalNav.render));
    store.subscribe(createReduxListener(store, 'chrome.appNav', appNav.render));

    const actions = dispatchActionsToStore(actionTemplates, store);
    return { store, middlewareListener, actions};
}