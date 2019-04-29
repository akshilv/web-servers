<template>
  <div style="height:100%">
    <LoginUser/>
  </div>
</template>

<script>
// @ is an alias to /src
import LoginUser from '@/components/LoginUser.vue';

export default {
  name: 'login',
  components: {
    LoginUser,
  },
};
</script>
