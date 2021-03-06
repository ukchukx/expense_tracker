// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
// import 'phoenix_html';
// import { Socket } from 'phoenix';
// import NProgress from 'nprogress';
// import { LiveSocket } from 'phoenix_live_view';

// let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
// let liveSocket = new LiveSocket("/live", Socket, { params: {_csrf_token: csrfToken } });

// Show progress bar on live navigation and form submits
// window.addEventListener("phx:page-loading-start", info => NProgress.start());
// window.addEventListener("phx:page-loading-stop", info => NProgress.done());

// connect if there are any LiveViews on the page
// liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// window.liveSocket = liveSocket;

import Vue from 'vue';
import VueCompositionAPI from '@vue/composition-api';
import axios from 'axios';

import Signin from '@/components/Signin';
import Signup from '@/components/Signup';
import Budget from '@/components/Budget';
import Account from '@/components/Account';
import Budgets from '@/components/Budgets';
import Page from '@/components/Page';
import CurrentBudget from '@/components/CurrentBudget';
import LineItem from '@/components/LineItem';

Vue.config.productionTip = false;

const token = document.head.querySelector('meta[name="csrf-token"]');
if (token) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
}

Vue.use(VueCompositionAPI);
Vue.component(Signin.name, Signin);
Vue.component(Signup.name, Signup);
Vue.component(Budget.name, Budget);
Vue.component(Account.name, Account);
Vue.component(Budgets.name, Budgets);
Vue.component(Page.name, Page);
Vue.component(CurrentBudget.name, CurrentBudget);
Vue.component(LineItem.name, LineItem);

new Vue({ el: '#app' });
