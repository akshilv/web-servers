<template>
  <div class="home">
    <h1>Login Page</h1>
    <LoginUser/>
  </div>
</template>

<script>
// @ is an alias to /src
import LoginUser from '@/components/LoginUser.vue';

export default {
  name: 'Login',
  components: {
    LoginUser,
  },
};
</script>
