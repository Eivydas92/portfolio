import React from 'react';


class App extends React.Component {

state = {
  value: '',
  email: '',
  password: '',
  address: '',
  age: ''
}; 

getValue = (event) => {
const name = event.target.name;
const value = event.target.value;

this.setState({[name]: value});

}

HandleSubmit = (event) => {
event.preventDefault(); //stop reloading
const email = this.state.email;
const password = this.state.password;
const address = this.state.address;
const age = this.state.age;
console.log('Email on submit: ', email);
console.log('Password on submit: ', password);
console.log('Address on submit: ', address);
console.log('Age on submit: ', age);
//to do

};

render() {
console.log('State: ', this.state);

return(
<div>

<h1>Welcome</h1>

<form action="">
<div>
<label htmlFor=""></label>
<input type="email" onChange = {this.getValue} name = 'email'/>
</div>

<div>
<label htmlFor=""></label>
<input type="password" onChange = {this.getValue} name = 'password'/>
</div>

<div>
<label htmlFor=""></label>
<input type="text" onChange = {this.getValue} name = 'address'/>
</div>


<div>
<label htmlFor=""></label>
<input type="number" onChange = {this.getValue} name = 'age'/>
</div>


<button onClick = {this.HandleSubmit}>Submit</button>
</form>
</div>



)




}



}

export default App;
