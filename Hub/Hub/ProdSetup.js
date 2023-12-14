

function ProdSetup(fs) {
    let certFile = '/etc/letsencrypt/live/dashboard.argusdentalvision.com/fullchain.pem';
    let keyFile = '/etc/letsencrypt/live/dashboard.argusdentalvision.com/privkey.pem';

    let key         = fs.readFileSync(keyFile);
    let cert        = fs.readFileSync(certFile);
    
    return { }
};

module.exports = { ProdSetup }
