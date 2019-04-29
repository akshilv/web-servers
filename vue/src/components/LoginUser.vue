<template>
  <v-contianer>
    <v-layout align-center="true" justify-center="true" style="height:100%">
      <v-flex xs12 sm6 md3>
        <v-form
          @submit="loginUser"
          onSubmit="return false">
          <v-alert
            :value="error"
            type="error">
            {{ errorMessage }}
          </v-alert>  
          <v-card>
            <v-toolbar dark color="primary">
              <v-toolbar-title>Login Page</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-text-field
                label="User Name"
                outline
                v-model="userName">
              </v-text-field>
              <v-text-field
                label="Password"
                outline
                type="password"
                v-model="password">
              </v-text-field>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="primary" type="submit" value="Submit">Login</v-btn>
            </v-card-actions>
          </v-card>
        </v-form>
      </v-flex>
    </v-layout>
  </v-contianer>
</template>

<script>
export default {
  name: 'LoginUser',
  data () {
    return {
      userName: '',
      password: '',
      error: false,
      errorMessage: '',
    }
  },
  methods: {
    /**
     * Function to login user
     */
    loginUser () {
      if (this.userName === 'admin' && this.password === 'admin') {
        this.$router.push('home');
      } else {
        this.error = true;
        this.errorMessage = 'Username or Password is incorrect';
      }
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
