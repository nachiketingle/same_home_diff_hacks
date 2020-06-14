let api_keys = JSON.parse(process.env.YELP_API_KEYS);

module.exports = {
  getApiKey: () => {
    let key = api_keys.shift();
    api_keys.push(key);
    return key;
  }
}
