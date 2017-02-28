####Benchmarker.py written by Hieronimus Loho and Adam Chekroud
#This script scrapes the NYT Article Search API metadata for the number of hits per quarter 
#for a list of terms loaded from a .txt file. The script can also rotate through a list of NYT API keys. 


##### NewYorkTimes python package by Evan Sherlock, slightly modified by Hieronimus Loho
##### from https://github.com/evansherlock/nytimesarticle 

import requests

API_ROOT = 'http://api.nytimes.com/svc/search/v2/articlesearch.'

class articleAPI(object):
    def __init__(self, key = None):
        """
        Initializes the articleAPI class with a developer key. Raises an exception if a key is not given.
        
        Request a key at http://developer.nytimes.com/docs/reference/keys
        
        :param key: New York Times Developer Key
        
        """
        self.key = key
        self.response_format = 'json'
        
        if self.key is None:
            raise NoAPIKeyException('Warning: Missing API Key. Please visit ' + API_SIGNUP_PAGE + ' to register for a key.')
    
    def _utf8_encode(self, d):
        """
        Ensures all values are encoded in UTF-8 and converts them to lowercase
        
        """
        

        #******Edit: Got rid of .lower(), because that messes up the Lucene modifiers OR, AND ********************



        for k, v in d.items():
            if isinstance(v, str):
                d[k] = v.encode('utf8')
            if isinstance(v, list):
                for index,item in enumerate(v):
                    item = item.encode('utf8')
                    v[index] = item
            if isinstance(v, dict):
                d[k] = self._utf8_encode(v)
        
        return d
    
    def _bool_encode(self, d):
        """
        Converts bool values to lowercase strings
        
        """
        for k, v in d.items():
            if isinstance(v, bool):
                d[k] = str(v).lower()
        
        return d

    def _options(self, **kwargs):
        """
        Formats search parameters/values for use with API
        
        :param \*\*kwargs: search parameters/values
        
        """
        def _format_fq(d):
            for k,v in d.items():
                if isinstance(v, list):
                    d[k] = ' '.join(map(lambda x: '"' + x + '"', v))
                else:
                    d[k] = '"' + v + '"'
            values = []
            for k,v in d.items():
                value = '%s:(%s)' % (k,v)
                values.append(value)
            values = ' AND '.join(values)
            return values
        
        kwargs = self._utf8_encode(kwargs)
        kwargs = self._bool_encode(kwargs)
        
        values = ''
        
        for k, v in kwargs.items():
            if k is 'fq' and isinstance(v, dict):
                v = _format_fq(v)
            elif isinstance(v, list):
                v = ','.join(v)
            values += '%s=%s&' % (k, v)
        
        return values

    def search(self, 
                response_format = None, 
                key = None, 
                **kwargs):
        """
        Calls the API and returns a dictionary of the search results
        
        :param response_format: the format that the API uses for its response, 
                                includes JSON (.json) and JSONP (.jsonp). 
                                Defaults to '.json'.
                                
        :param key: a developer key. Defaults to key given when the articleAPI class was initialized.
        
        """
        if response_format is None:
            response_format = self.response_format
        if key is None:
            key = self.key
        
        url = '%s%s?%sapi-key=%s' % (
            API_ROOT, response_format, self._options(**kwargs), key
        )
        r = requests.get(url)
        return r.json()

##### End of Evan Sherlock's newyorktimesarticle package ***********************************************************************








##### Original code by Hieronimus Loho and Adam Chekroud that utilizes the above newyorktimesarticle package
#import necessary dictionaries
import csv
import time
import os
#Load list of 7 API keys to cycle through
api_counter = 0
api_file = open("/Users/hieronimusloho/Box Sync/Research Stuff/NYTLocal/NYT_keys.txt", "r")
api_list = api_file.read().split('\n')

#Initialize first API key
api = articleAPI(api_list[api_counter])

#Load in a list of search terms written in Lucene query syntax
terms_file = open("/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/terms/benchmark_terms.txt", "r")
terms = terms_file.read().split('\n')
print terms

#Load a separate file of list of shortened/clean search terms that are easier to display
display_file = open("/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/terms/display_benchmark_terms.txt", "r")
disp_terms = display_file.read().split('\n')

#Where the CSVs will be written out
write_out_path = '/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/CSVs/'

#Start and end years
start_year = 1900
end_year = 2016

#Parses the JSON response and returns the year, # of hits from the metadata, the term, and what quarter it was in.
def parse_articles(articles, year, term, quarter):
    shell = []
    dic = {}
    dic['year'] = year
    dic['hits'] = articles['response']['meta']['hits']
    dic['term'] = term
    dic['quarter'] = quarter
    shell.append(dic)
    return(shell)
#In the unlikely event that the get_articles script fails, this function will record which year and quarter failed.
def parse_articles_failed(year, term, quarter):
    shell = []
    dic = {}
    dic['year'] = year
    dic['hits'] = "failed"
    dic['term'] = term
    dic['quarter'] = quarter
    shell.append(dic)
    return(shell)


#This is the function that utilizes Evan Sherlock's python script (see above) to make the JSON requests.
def get_articles(date,query,disp):
    '''
    This function accepts a year in string format (e.g.'1970'), a query (e.g. "mental illness"), 
    and the display term, or what you would like to call that term on the CSV (to make things cleaner 
    since LUCENE syntax can get messy. Then, it will return a list four parsed (see above function) dictionaries 
    (one for each quarter) for that year.
    '''
    global api_counter
    global api
    all_articles = []
    page_counter = 0
    quarter = 1
    while quarter < 5:
        time.sleep(1)
        daymorangebeg = ['0101','0401','0701','1001']
        daymorangeend = ['0331','0630','0930','1231']
        try:
            articles = api.search(fq = query,
                begin_date = date + daymorangebeg[quarter - 1],
                end_date = date + daymorangeend[quarter - 1],
                sort='oldest',
                page = str(page_counter))
            print dict.keys(articles)
            page_counter = 0
            if articles.has_key('response'):
                articles = parse_articles(articles, date, disp, quarter)
                print articles
                all_articles += articles
            ###This recognizes when the current API key is out of queries for the day, and switches it out for a fresh one
            elif articles.has_key('message'):
                        if api_counter < (len(api_list) -1):
                            print "Ran out of queries for api key" + str(api_list[api_counter]) + "for the day"
                            api_counter += 1
                            api = articleAPI(api_list[api_counter])
                        else:
                            print "Out of API queries for the day, pausing for 1 day"
                            api_counter = 0 
                            api = articleAPI(api_list[api_counter])
                            pause.days(1)    
            else: 
                print "Quarter " + str(quarter) + " does not have a response"
            quarter += 1
        
        # Some NYT requests get shut down with a 403 Error, so just switch to a different page of the results list,
        # because they all have the same 'hits' metadata (so long as the start and end dates are the same). This script will 
        # keep trying different pages for the same year and quarter timepoint until it gets a valid response.
        
        except ValueError:
            print ValueError
            if page_counter < 100:
                page_counter  += 1
                print "403 Forbidden page, trying next page" + str(page_counter)
            else:
                articles = parse_articles_failed(date,disp,quarter)
                print articles
                quarter += 1
                all_articles += articles
    return all_articles


#This function writes out the python dictionary as a csv
def write_csv(dictionary, path, term, begin, end):   
    keys = dictionary[0].keys()
    open_file_path = path + term + "_" + str(begin) + 'to' + str(end) + '.csv'
    with open(open_file_path, 'wb') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(dictionary)
    print open_file_path 


#The main function that takes the list of search terms, the begin and end years, the display terms, and the path where you want
#to save the CSV. 
def main(search_terms, begin, end, disp_terms, write_out_path):
    global query_results
    for term_number in range(0,len(search_terms)):
        #Adds the year and hits to the list   
        query_results = []
        print search_terms[term_number]
        for year in range(begin,end + 1):
            print 'Processing' + str(year) + '...'
            results_for_year =  get_articles(str(year),search_terms[term_number], disp_terms[term_number])
            query_results += results_for_year
        if query_results != []:
            write_csv(query_results, write_out_path, disp_terms[term_number], begin, end)

main(terms, start_year, end_year, disp_terms, write_out_path)