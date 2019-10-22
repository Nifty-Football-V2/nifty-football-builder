<template>
    <div id="app" class="container-fluid mt-5">
        <div class="row">
            <div class="col-12 col-sm-6" v-if="chainId">
                <img :src="`https://niftyfootball.cards/api/network/4/image/ethnicity/${ethnicity}/kit/${kit}/colour/${colour}/firstName/${firstName}/lastName/${lastName}/position/${position}/nationality/${nationality}/sponsor/${sponsor}/boots/0/number/0`"/>

                <hr/>

                <b-form>
                    <b-form-group id="ethAccount" label="ETH Account:" label-for="ethAccount">
                        <b-form-input v-model="ethAccount" required></b-form-input>
                    </b-form-group>
                    <code>{{ ethAccount }}</code>
                </b-form>

                <b-button variant="danger" @click="mintPlayer" class="float-right m-5" size="lg">
                    Mint on {{ contracts.getNetwork(chainId).toUpperCase() }}
                </b-button>

                <b-button variant="warning" @click="directMintPlayer" class="float-right m-5" size="lg">
                    DIRECT Mint on {{ contracts.getNetwork(chainId).toUpperCase() }}
                </b-button>
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
                                <b-form-select id="nation" :options="niftyData.nationalityOptions" required v-model="nationality" v-on:change="flushNames"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="position" label="Position:" label-for="position">
                                <b-form-select v-model="position" :options="niftyData.positionOptions" required/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="sponsor" label="Sponsor:" label-for="sponsor">
                                <b-form-input v-model="sponsor" :options="niftyData.positionOptions" required/>
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
                    nationality: {{nationality}}<br/>
                    position: {{position}}<br/>
                    ethnicity: {{ethnicity}}<br/>
                    kit: {{kit}}<br/>
                    colour: {{colour}}<br/>
                    firstName: {{firstName}}<br/>
                    lastName: {{lastName}}<br/>
                    to<br/>
                </code>
            </div>
        </div>
    </div>
</template>

<script>
    import Portis from '@portis/web3';

    import axios from 'axios';
    import { ethers } from 'ethers';
    import { contracts } from 'nifty-football-contract-tools';
    import BFormText from 'bootstrap-vue/src/components/form/form-text';
    import BFormInput from 'bootstrap-vue/src/components/form-input/form-input';

    export default {
        name: 'app',
        data() {
            return {
                niftyData: null,
                nationality: 44,
                position: 3,
                ethnicity: 0,
                kit: 0,
                colour: 0,
                firstName: 0,
                lastName: 0,
                sponsor: 0,
                chainId: null,
                provider: null,
                signer: null,
                contracts: contracts,
                ethAccount: null,
            };
        },
        components: {BFormInput, BFormText},
        methods: {
            getRootApi() {
                // return 'https://niftyfootball.cards/api';
                return 'http://localhost:5000/futbol-cards/us-central1/main/api';
            },
            async mintPlayer() {

                // our default is mainnet so override
                const getNetworkString = (network) => {
                    return contracts.networkSplitter(network, {
                        mainnet: 'homestead',
                        ropsten: 'ropsten',
                        rinkeby: 'rinkeby',
                        local: 'homestead'
                    });
                };

                const value = 0; // this is admin and free!
                const {address, abi} = contracts.getNiftyFootballAdmin(contracts.getNetwork(this.chainId));

                console.log(`Calling ${getNetworkString(this.chainId)} [${contracts.getNetwork(this.chainId)}] address: ${address}`);

                const niftyFootballAdminContract = new ethers.Contract(
                    address,
                    abi,
                    this.signer,
                );

                const gasPrice = await ethers.getDefaultProvider(getNetworkString(this.chainId)).getGasPrice();
                const gasLimit = await niftyFootballAdminContract.estimate.generateAndAssignCard(
                    this.nationality,
                    this.position,
                    this.ethnicity,
                    this.kit,
                    this.colour,
                    this.firstName,
                    this.lastName,
                    this.ethAccount.trim(),
                    {value: value}
                );

                if (this.ethAccount) {
                    console.log(`minting to ${this.ethAccount} on ${contracts.getNetwork(this.chainId)}`);

                    let overrides = {
                        gasLimit: gasLimit.add(100000), // The maximum units of gas for the transaction to use
                        gasPrice: gasPrice,  // The price (in wei) per unit of gas
                        value: value,
                    };

                    // wait for tx to be mined
                    let tx = await niftyFootballAdminContract.generateAndAssignCard(
                        this.nationality,
                        this.position,
                        this.ethnicity,
                        this.kit,
                        this.colour,
                        this.firstName,
                        this.lastName,
                        this.ethAccount.trim(),
                        overrides
                    );

                    let receipt = await tx.wait(1);
                    console.log(`Rec:`, receipt);
                }
            },
            async directMintPlayer() {

                // our default is mainnet so override
                const getNetworkString = (network) => {
                    return contracts.networkSplitter(network, {
                        mainnet: 'homestead',
                        ropsten: 'ropsten',
                        rinkeby: 'rinkeby',
                        local: 'homestead'
                    });
                };

                const {address, abi} = contracts.getNiftyFootballNft(contracts.getNetwork(this.chainId));

                console.log(`Calling ${getNetworkString(this.chainId)} [${contracts.getNetwork(this.chainId)}] address: ${address}`);

                const niftyFootballNftContract = new ethers.Contract(
                    address,
                    abi,
                    this.signer,
                );

                if (this.ethAccount) {
                    console.log(`minting to ${this.ethAccount} on ${contracts.getNetwork(this.chainId)}`);

                    // wait for tx to be mined
                    let tx = await niftyFootballNftContract.mintCard(
                        0,
                        this.nationality,
                        this.position,
                        this.ethnicity,
                        this.kit,
                        this.colour,
                        this.ethAccount.trim(),
                        {value: 0, gasLimit: 750000}
                    );

                    let receipt = await tx.wait(1);
                    console.log(`Rec:`, receipt);
                }
            },
            async flushNames() {
                this.niftyData.firstNameOptions = [];
                Object.keys(this.niftyData.nations[this.nationality].firstNames).forEach(
                    (k) => this.niftyData.firstNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].firstNames[k].latin}`})
                );

                this.niftyData.lastNameOptions = [];
                Object.keys(this.niftyData.nations[this.nationality].lastNames).forEach(
                    (k) => this.niftyData.lastNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].lastNames[k].latin}`})
                );
            },
        },
        async created() {

            this.portis = new Portis('b96ecc12-e7bc-4178-a489-ffd4bbb703ef', 'rinkeby', { gasRelay: true });
            this.provider = new ethers.providers.Web3Provider(this.portis.provider);

            const accounts = await this.provider.listAccounts();
            console.log(accounts);

            this.ethAccount = accounts[0];

            this.signer = this.provider.getSigner();

            // console.log(this.provider.network.name);
            // const {chainId} = this.provider.network.name;
            this.chainId = 4;

            const rootApi = await this.getRootApi();

            const res = await axios.get(`https://niftyfootball.cards/api/network/4/image/data`);
            this.niftyData = res.data;

            // this could be better...I admit
            this.niftyData.kitOptions = [];
            Object.keys(this.niftyData.kits).forEach(
                (k, i) => this.niftyData.kitOptions.push({value: k, text: `${i} - ${this.niftyData.kits[k].name}`})
            );

            this.niftyData.coloursOptions = [];
            Object.keys(this.niftyData.colours).forEach(
                (k, i) => this.niftyData.coloursOptions.push({value: k, text: `${i} - ${this.niftyData.colours[k].name}`})
            );

            this.niftyData.nationalityOptions = [];
            Object.keys(this.niftyData.nations).forEach(
                (k) => this.niftyData.nationalityOptions.push({value: k, text: `${k} - ${this.niftyData.nations[k].name}`})
            );

            this.niftyData.ethnicitiesOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].ethnicities).forEach(
                (k) => this.niftyData.ethnicitiesOptions.push({value: k, text: k})
            );

            this.niftyData.positionOptions = [];
            Object.keys(this.niftyData.positions).forEach(
                (k, i) => this.niftyData.positionOptions.push({value: this.niftyData.positions[k], text: `${i} - ${k}`})
            );

            this.niftyData.firstNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].firstNames).forEach(
                (k) => this.niftyData.firstNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].firstNames[k].latin}`})
            );

            this.niftyData.lastNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].lastNames).forEach(
                (k) => this.niftyData.lastNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].lastNames[k].latin}`})
            );
        }
    };
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        color: #2c3e50;
    }
</style>
