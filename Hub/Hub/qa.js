function QASetup(fs) {
    let sslRoot     = (process.platform === 'win32') ? '/var/Apache/Server' : '/etc/apache2';
    //sslRoot = '/var/Apache/Server';
    let key         = fs.readFileSync(sslRoot+'/ssl.key/dashboard.argusdentalvision.com.key');
    let cert        = fs.readFileSync(sslRoot+'/ssl.crt/cddb2a7bbedf5bdf.crt' );
    let ca          = fs.readFileSync(sslRoot+'/ssl.crt/gd_bundle-g2-g1.crt' );
};
module.exports = { QASetup };
