<template>
  <div class="home">
    <Users msg="Welcome to web-server App"/>
  </div>
</template>

<script>
// @ is an alias to /src
import Users from '@/components/Users.vue';

export default {
  name: 'home',
  components: {
    Users,
  },
};
</script>
