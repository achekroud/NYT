####total_articles.py written by Hieronimus Loho and Adam Chekroud
'''
This script pulls the total number of articles in the NYT per quarter per year, just as a reference point.
It is very similar to the benchmarker.py script, just without the rotating keys and without any search terms. 
'''
from nytimesarticle import articleAPI
import csv
import time
import os
#Insert API Key
api_file = open("/Users/hieronimusloho/Box Sync/Research Stuff/NYTLocal/NYT_keys.txt", "r")
api_list = api_file.read().split('\n')
api = articleAPI(api_list[6])
mental_health = []
#Start and end year 
begin = 1900
end = 2016
#Returns the hits response of the metadata
def parse_articles(articles, year, quarter):
    shell = []
    dic = {}
    dic['year'] = year
    dic['hits'] = articles['response']['meta']['hits']
    dic['quarter'] = quarter
    shell.append(dic)
    return(shell)
def parse_articles_failed(year, quarter):
    shell = []
    dic = {}
    dic['year'] = year
    dic['hits'] = "failed"
    dic['quarter'] = quarter
    shell.append(dic)
    return(shell)

#Function to query each year for the term
def get_articles(date):
    '''
    This function accepts a year in string format (e.g.'1980')
    and a query (e.g.'Amnesty International') and it will 
    return a list of parsed articles (in dictionaries)
    for that year.
    '''
    all_articles = []
    page_counter = 0
    quarter = 1
    daymorangebeg = ['0101','0401','0701','1001']
    daymorangeend = ['0331','0630','0930','1231']
    while quarter < 5:
        time.sleep(1)
        try:
            articles = api.search(
                begin_date = date + daymorangebeg[quarter - 1],
                end_date = date + daymorangeend[quarter - 1],
                sort='oldest',
                page = str(page_counter))
            print dict.keys(articles)
            page_counter = 0
            if articles.has_key('response'):
                articles = parse_articles(articles, date, quarter)
                print articles
                all_articles += articles
            else: 
                print "Quarter " + str(quarter) + " does not have a response"
            quarter += 1
        except ValueError:
            print ValueError
            if page_counter < 50:
                page_counter += 1
                print "403 Forbidden page, trying next page" + str(page_counter)
            else:
                articles = parse_articles_failed(date,disp,quarter)
                print articles
                quarter += 1
                all_articles += articles
    return(all_articles)

def writer(dictionary, path):   
    keys = dictionary[0].keys()
    with open(path + "_" + str(begin) + 'to' + str(end) + '.csv', 'wb') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(dictionary)

def main():
    global mental_health
    #Adds the year and hits to the list   
    for year in range(begin,end + 1):
        print 'Processing' + str(year) + '...'
        mental_health_year = []
        mental_health_year =  get_articles(str(year))
        mental_health += mental_health_year
    #Write out the list as a csv
    path1 = '/Users/hieronimusloho/Box Sync/Research Stuff/NewYorkTimes/CSVs/hits/total_per_quarter(no_oldest_sort)'
    writer(mental_health, path1)

main()
