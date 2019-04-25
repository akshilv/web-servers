<template>
  <div>
    <h1>Welcome {{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: 'Users',
  props: {
    msg: String,
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
