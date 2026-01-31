const firebase = require('firebase-tools');
const path = require('path');

async function deploy() {
  try {
    await firebase.deploy({
      project: 'saeedkhanportfolio',
      only: 'hosting',
      cwd: __dirname
    });
    console.log('Deployment successful!');
  } catch (error) {
    console.error('Deployment failed:', error);
  }
}

deploy();
