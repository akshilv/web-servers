import Vue from 'vue';
import Vuetify from 'vuetify';
import 'vuetify/dist/vuetify.min.css';
import colors from 'vuetify/es5/util/colors';

import App from './App.vue';
import router from './router';
import store from './store';

Vue.config.productionTip = false;
Vue.use(Vuetify, {
  theme: {
    primary: colors.blue.darken1, // #E53935
    secondary: colors.teal.lighten3, // #FFCDD2
    accent: colors.orange.darken3, // #3F51B5
  },
});

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app');
