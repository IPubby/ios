#import "Article.h"

@implementation Article

+ (NSArray *)demoArticles
{
    NSMutableArray *articles = [NSMutableArray array];

    Article *article0 = [[Article alloc] init];
    article0.abstract = @"Nicholas Mevoli was competing at Vertical Blue, a championship event in the sport of free diving, where he was attempting to achieve his second American record.";
    article0.byline = @"By ADAM SKOLNICK";
    article0.remoteId = @"100000002557161";
    article0.publishedDate = @"2013-11-18";
    article0.section = @"Sports";
    article0.source = @"The New York Times";
    article0.title = @"A Deep-Water Diver From Brooklyn Dies After Trying for a Record";
    article0.url = @"http://www.nytimes.com/2013/11/18/sports/deep-water-diver-from-brooklyn-dies-after-trying-for-a-record.html";
    [articles addObject:article0];

    Article *article1 = [[Article alloc] init];
    article1.abstract = @"An online calculator meant to help doctors assess treatment options appears to overestimate risk, so much so that it could mistakenly suggest that millions more people are candidates for statin drugs.";
    article1.byline = @"By GINA KOLATA";
    article1.remoteId = @"100000002557178";
    article1.publishedDate = @"2013-11-18";
    article1.section = @"Health";
    article1.source = @"The New York Times";
    article1.title = @"Risk Calculator for Cholesterol Appears Flawed";
    article1.url = @"http://www.nytimes.com/2013/11/18/health/risk-calculator-for-cholesterol-appears-flawed.html";
    [articles addObject:article1];

    Article *article2 = [[Article alloc] init];
    article2.abstract = @"Mary Cheney and her wife sharply criticized a comment by Ms. Cheney&#8217;s sister, Liz Cheney, a candidate for the Senate in Wyoming.";
    article2.byline = @"By JONATHAN MARTIN";
    article2.remoteId = @"5";
    article2.publishedDate = @"2013-11-17";
    article2.section = @"U.S.";
    article2.source = @"The New York Times";
    article2.title = @"Dispute Over Gay Marriage Erupts in Cheney Family ";
    article2.url = @"http://thecaucus.blogs.nytimes.com/2013/11/17/within-cheney-family-a-dispute-over-gay-marriage/";
    [articles addObject:article2];

    Article *article3 = [[Article alloc] init];
    article3.abstract = @"The new normal for our economy may be a state of mild depression.";
    article3.byline = @"By PAUL KRUGMAN";
    article3.remoteId = @"100000002557126";
    article3.publishedDate = @"2013-11-18";
    article3.section = @"Opinion";
    article3.source = @"The New York Times";
    article3.title = @"A Permanent Slump?";
    article3.url = @"http://www.nytimes.com/2013/11/18/opinion/krugman-a-permanent-slump.html";
    [articles addObject:article3];

    Article *article4 = [[Article alloc] init];
    article4.abstract = @"John Moffitt, who walked away from about $1 million in salary from the 9-1 Broncos, said continuing to play for money was likely to injure him further and deepen his gloom.";
    article4.byline = @"By KEN BELSON";
    article4.remoteId = @"100000002558075";
    article4.publishedDate = @"2013-11-19";
    article4.section = @"Sports";
    article4.source = @"The New York Times";
    article4.title = @"Quitting the N.F.L.: For John Moffitt, the Money Wasn’t Worth It";
    article4.url = @"http://www.nytimes.com/2013/11/19/sports/football/quitting-the-nfl-for-john-moffitt-the-money-wasnt-worth-it.html";
    [articles addObject:article4];

    Article *article5 = [[Article alloc] init];
    article5.abstract = @"People in the United States pay more and get less than citizens in other advanced countries.";
    article5.byline = @"By THE EDITORIAL BOARD";
    article5.remoteId = @"100000002557150";
    article5.publishedDate = @"2013-11-18";
    article5.section = @"Opinion";
    article5.source = @"The New York Times";
    article5.title = @"The Shame of American Health Care";
    article5.url = @"http://www.nytimes.com/2013/11/18/opinion/the-shame-of-american-health-care.html";
    [articles addObject:article5];

    Article *article6 = [[Article alloc] init];
    article6.abstract = @"Severe storms carved paths of destruction through the Midwest on Sunday, destroying towns, killing at least six people and causing thousands of power failures.";
    article6.byline = @"By EMMA G. FITZSIMMONS";
    article6.remoteId = @"100000002556774";
    article6.publishedDate = @"2013-11-18";
    article6.section = @"U.S.";
    article6.source = @"The New York Times";
    article6.title = @"Scores of Tornadoes Slam Midwest States";
    article6.url = @"http://www.nytimes.com/2013/11/18/us/severe-storms-batter-central-illinois.html";
    [articles addObject:article6];

    Article *article7 = [[Article alloc] init];
    article7.abstract = @"How America&#8217;s agricultural programs increase inequality at home and abroad.";
    article7.byline = @"By JOSEPH E. STIGLITZ";
    article7.remoteId = @"289";
    article7.publishedDate = @"2013-11-16";
    article7.section = @"Opinion";
    article7.source = @"The New York Times";
    article7.title = @"The Insanity of Our Food Policy";
    article7.url = @"http://opinionator.blogs.nytimes.com/2013/11/16/the-insanity-of-our-food-policy/";
    [articles addObject:article7];

    Article *article8 = [[Article alloc] init];
    article8.abstract = @"Former Vice President Dick Cheney and his wife said the feud pained them, but supported Liz Cheney, whose opposition to same-sex marriage has prompted criticism from her sister, Mary, who has a same-sex spouse.";
    article8.byline = @"By JONATHAN MARTIN";
    article8.remoteId = @"100000002558392";
    article8.publishedDate = @"2013-11-19";
    article8.section = @"U.S.";
    article8.source = @"The New York Times";
    article8.title = @"Cheneys Defend Elder Daughter in Feud on Gay Marriage";
    article8.url = @"http://www.nytimes.com/2013/11/19/us/politics/in-cheneys-gay-marriage-feud-parents-defend-liz.html";
    [articles addObject:article8];

    Article *article9 = [[Article alloc] init];
    article9.abstract = @"Older voters rebelled when Medicare benefits were expanded at the cost of higher premiums, and some lawmakers who were involved see parallels today.";
    article9.byline = @"By CARL HULSE";
    article9.remoteId = @"100000002557147";
    article9.publishedDate = @"2013-11-18";
    article9.section = @"U.S.";
    article9.source = @"The New York Times";
    article9.title = @"Lesson Is Seen in Failure of Law on Medicare in 1989";
    article9.url = @"http://www.nytimes.com/2013/11/18/us/politics/lesson-is-seen-in-failure-of-1989-law-on-medicare.html";
    [articles addObject:article9];

    Article *article10 = [[Article alloc] init];
    article10.abstract = @"Neither Republicans nor Democrats want to take even the actions they demand of the other side for a long-sought agreement on the nation&#8217;s fiscal future.";
    article10.byline = @"By JACKIE CALMES";
    article10.remoteId = @"100000002557788";
    article10.publishedDate = @"2013-11-19";
    article10.section = @"U.S.";
    article10.source = @"The New York Times";
    article10.title = @"A Dirty Secret Lurks in the Struggle Over a Fiscal &#8216;Grand Bargain&#8217;";
    article10.url = @"http://www.nytimes.com/2013/11/19/us/politics/the-hidden-hurdles-to-a-fiscal-grand-bargain.html";
    [articles addObject:article10];

    Article *article11 = [[Article alloc] init];
    article11.abstract = @"After disputing reports that top editors had killed an article on China for political reasons, Bloomberg News suspended the reporter Michael Forsythe.";
    article11.byline = @"By EDWARD WONG and CHRISTINE HAUGHNEY";
    article11.remoteId = @"100000002556539";
    article11.publishedDate = @"2013-11-18";
    article11.section = @"World";
    article11.source = @"The New York Times";
    article11.title = @"Bloomberg News Suspends Reporter Whose Article on China Was Not Published";
    article11.url = @"http://www.nytimes.com/2013/11/18/world/asia/reporter-on-unpublished-bloomberg-article-is-suspended.html";
    [articles addObject:article11];

    Article *article12 = [[Article alloc] init];
    article12.abstract = @"In some areas, an unregulated clinic scene has sprung up for buprenorphine, a drug used to treat addiction, and it can pose a turbulent setting for patient care.";
    article12.byline = @"By DEBORAH SONTAG";
    article12.remoteId = @"100000002555276";
    article12.publishedDate = @"2013-11-18";
    article12.section = @"Health";
    article12.source = @"The New York Times";
    article12.title = @"At Clinics, Tumultuous Lives and Turbulent Care";
    article12.url = @"http://www.nytimes.com/2013/11/18/health/at-clinics-tumultuous-lives-and-turbulent-care.html";
    [articles addObject:article12];

    Article *article13 = [[Article alloc] init];
    article13.abstract = @"Portrayed by people in blackface makeup, Peter sports outlandish Renaissance costumes, with thick red lips and frizzy hairdo wigs or fake dreadlocks.";
    article13.byline = @"By JOHN TAGLIABUE";
    article13.remoteId = @"100000002556569";
    article13.publishedDate = @"2013-11-18";
    article13.section = @"World";
    article13.source = @"The New York Times";
    article13.title = @"Where St. Nicholas Has His Black Pete(s), Charges of Racism Follow";
    article13.url = @"http://www.nytimes.com/2013/11/18/world/europe/where-st-nicholas-has-his-black-petes-charges-of-racism-follow.html";
    [articles addObject:article13];

    Article *article14 = [[Article alloc] init];
    article14.abstract = @"George Zimmerman, who was acquitted in the fatal shooting of an unarmed black teenager, was arrested after a dispute with his girlfriend, the authorities said.";
    article14.byline = @"By ALAN BLINDER";
    article14.remoteId = @"100000002558382";
    article14.publishedDate = @"2013-11-19";
    article14.section = @"U.S.";
    article14.source = @"The New York Times";
    article14.title = @"Zimmerman Is Charged With Aggravated Assault";
    article14.url = @"http://www.nytimes.com/2013/11/19/us/zimmerman-is-arrested-in-florida.html";
    [articles addObject:article14];

    Article *article15 = [[Article alloc] init];
    article15.abstract = @"Anal fissures, or tears in the anal opening, are not exactly a topic for cocktail party conversation, but the condition is quite common.";
    article15.byline = @"By JANE E. BRODY";
    article15.remoteId = @"24";
    article15.publishedDate = @"2013-11-18";
    article15.section = @"Health";
    article15.source = @"The New York Times";
    article15.title = @"A Pain That's Hard to Discuss";
    article15.url = @"http://well.blogs.nytimes.com/2013/11/18/a-pain-thats-hard-to-discuss/";
    [articles addObject:article15];

    Article *article16 = [[Article alloc] init];
    article16.abstract = @"Cornelius Gurlitt, the reclusive son of a Nazi-era art dealer, told a German newsmagazine that the confiscation of some 1,280 masterworks from his home was more devastating than his sister&#8217;s death.";
    article16.byline = @"By ANDREW HIGGINS and KATRIN BENNHOLD";
    article16.remoteId = @"100000002556102";
    article16.publishedDate = @"2013-11-18";
    article16.section = @"World";
    article16.source = @"The New York Times";
    article16.title = @"For Son of a Nazi-Era Dealer, a Private Life Amid a Tainted Trove of Art";
    article16.url = @"http://www.nytimes.com/2013/11/18/world/europe/a-private-life-amid-a-tainted-trove-of-art.html";
    [articles addObject:article16];

    Article *article17 = [[Article alloc] init];
    article17.abstract = @"A report highlights thousands of prisoners serving life without parole for nonviolent crimes.";
    article17.byline = @"By THE EDITORIAL BOARD";
    article17.remoteId = @"100000002555433";
    article17.publishedDate = @"2013-11-17";
    article17.section = @"Opinion";
    article17.source = @"The New York Times";
    article17.title = @"Sentenced to a Slow Death";
    article17.url = @"http://www.nytimes.com/2013/11/17/opinion/sunday/sentenced-to-a-slow-death.html";
    [articles addObject:article17];

    Article *article18 = [[Article alloc] init];
    article18.abstract = @"American spy agencies fear that allowing monitor stations in the United States for Russia’s version of GPS could compromise American intelligence.";
    article18.byline = @"By MICHAEL S. SCHMIDT and ERIC SCHMITT";
    article18.remoteId = @"100000002555962";
    article18.publishedDate = @"2013-11-17";
    article18.section = @"World";
    article18.source = @"The New York Times";
    article18.title = @"A Russian GPS Using U.S. Soil Stirs Spy Fears";
    article18.url = @"http://www.nytimes.com/2013/11/17/world/europe/a-russian-gps-using-us-soil-stirs-spy-fears.html";
    [articles addObject:article18];

    Article *article19 = [[Article alloc] init];
    article19.abstract = @"Ms. Lessing was an uninhibited and outspoken novelist who produced dozens of novels, short stories, essays and poems, embarking on dizzying and at times stultifying literary experiments.";
    article19.byline = @"By HELEN T. VERONGOS";
    article19.remoteId = @"100000002556555";
    article19.publishedDate = @"2013-11-18";
    article19.section = @"Books";
    article19.source = @"The New York Times";
    article19.title = @"Doris Lessing, Author Who Swept Aside Convention, Is Dead at 94";
    article19.url = @"http://www.nytimes.com/2013/11/18/books/doris-lessing-novelist-who-won-2007-nobel-is-dead-at-94.html";
    [articles addObject:article19];

    return articles;
}

@end