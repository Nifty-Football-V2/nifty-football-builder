<template>
    <div id="app" class="container-fluid mt-5">
        <div class="row">
            <div class="col-12 col-sm-6">
                <img style="max-height: 20rem"
                     :src="`${this.rootApi}network/1/image/ethnicity/${ethnicity}/kit/${kit}/colour/${colour}/firstName/${firstName}/lastName/${lastName}/position/${position}/nationality/${nationality}`"/>
            </div>
            <div class="col-12 col-sm-6">
                <b-form v-if="niftyData">

                    <div class="row">
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-select v-model="firstName" :options="niftyData.firstNameOptions" required/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-select v-model="lastName" :options="niftyData.lastNameOptions" required/>
                            </b-form-group>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <b-form-group id="nation" label="Nationality:" label-for="nation">
                                <b-form-select id="nation" :options="niftyData.nationalityOptions" required v-model="nationality"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="position" label="Position:" label-for="position">
                                <b-form-select v-model="position" :options="niftyData.positionOptions" required/>
                            </b-form-group>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-2">
                            <b-form-group id="ethnicity" label="Ethnicity:" label-for="ethnicity">
                                <b-form-select id="ethnicity" :options="niftyData.ethnicitiesOptions" required v-model="ethnicity"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="kit" label="Kit:" label-for="kit">
                                <b-form-select id="kit" :options="niftyData.kitOptions" required v-model="kit"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="colours" label="Colours:" label-for="colours">
                                <b-form-select id="colours" :options="niftyData.coloursOptions" required v-model="colour"/>
                            </b-form-group>
                        </div>
                    </div>

                </b-form>

                <hr/>

                <code>
                    firstName: {{firstName}}<br/>
                    lastName: {{lastName}}<br/>
                    nationality: {{nationality}}<br/>
                    position: {{position}}<br/>
                    ethnicity: {{ethnicity}}<br/>
                    kit: {{kit}}<br/>
                    colour: {{colour}}<br/>
                </code>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';

    export default {
        name: 'app',
        data () {
            return {
                // rootApi: 'https://niftyfootball.cards/api/',
                rootApi: 'http://localhost:5000/futbol-cards/us-central1/main/api/',
                niftyData: null,
                ethnicity: 0,
                kit: 0,
                colour: 0,
                firstName: 0,
                lastName: 0,
                position: 3,
                nationality: 44,
                ethnicitiesClone: {},
            };
        },
        components: {},
        methods: {},
        async created () {
            const res = await axios.get(`${this.rootApi}/network/1/image/data`);
            this.niftyData = res.data;

            this.niftyData.kitOptions = [];
            Object.keys(this.niftyData.kits).forEach((k, i) => this.niftyData.kitOptions.push({value: k, text: `${i} - ${this.niftyData.kits[k].name}`}));

            this.niftyData.coloursOptions = [];
            Object.keys(this.niftyData.colours).forEach((k, i) => this.niftyData.coloursOptions.push({value: k, text: `${i} - ${this.niftyData.colours[k].name}`}));

            this.niftyData.nationalityOptions = [];
            Object.keys(this.niftyData.nations).forEach((k) => this.niftyData.nationalityOptions.push({value: k, text: `${k} - ${this.niftyData.nations[k].name}`}));

            this.niftyData.ethnicitiesOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].ethnicities).forEach((k) => this.niftyData.ethnicitiesOptions.push({value: k, text: k}));

            this.niftyData.positionOptions = [];
            Object.keys(this.niftyData.positions).forEach((k, i) => this.niftyData.positionOptions.push({value: this.niftyData.positions[k], text: `${i} - ${k}`}));

            this.niftyData.firstNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].firstNames).forEach((k) => this.niftyData.firstNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].firstNames[k].latin}`}));

            this.niftyData.lastNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].lastNames).forEach((k) => this.niftyData.lastNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].lastNames[k].latin}`}));
        }
    };
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        color: #2c3e50;
    }
</style>
