Aplikacja Kolejkowa to aplikacja, która obsługuje działanie kolejek w urzędach. Zastępuje ona obecnie używany system
brania numerków z maszyny i patrzenia na wyświetlacze kiedy jest nasza kolej. W aplikacji możemy wybrać urząd oraz później
sprawę, w której chcemy w stanąć w kolejce do okienka. Jesteśmy informowani ile osób jest w kolejce ile jest otwartych
okienek oraz jakie numerki są aktualnie obsługiwane. Gdy następuja nasza kolej w aplikacji widzimy taką informację oraz
do którego okienka powinniśmy się udać. Za obsługę kolejek odpowiada serwer.

W moim zamierzeniu osoby obsługujące okienka miały by ze swojej strony w jakiejś formie możliwość obsługiwania kolejki.
Napisałem prowizoryczną stronę internetową, gdzie można połączyć się z serwerem, otworzyć okienko w wybranym urzędzie i
sprawie, przyjmywać kolejne numerki i zamknąć okienko. 
Żeby przetestować aplikację należy odpalić aplikację (min. ios16), serwer oraz stronę do obsługi okienka (można również
wysyłać wiadomości do serwera z terminalu przez takie narzędzia jak np. wscat). Jeśli chcielibyśmy nie odpalać którejś
z tych rzeczy na jednej maszynie należy oczywiście w odpowiednich miejscach zmienić adres z "localhost" na odpowiedni
adres ip.

Ważna uwaga! Serwer ten jest przykładem serweru dla Urzędu Dzielnicy Ursynów, gdyż w moim zamyśle istniałby oddzielny
serwer dla każdego urzędu. Aplikacja pozwala nam wybrać dowolny urząd jednak o ile nie jest to Urząd Dzielnicy Ursynów
nie będziemy mogli w nim dołączyć do kolejki.

ENGLISH

The Aplikacja Kolejkowa is an app that manages the operation of queues in offices. It replaces the currently used system
of taking numbers from a machine and looking at displays to see when it's our turn. In the app, we can choose an office
and then a specific matter in which we want to queue up for a service at the counter. We are informed about how many people are
in the queue, how many counters are open, and which numbers are currently being served. When it's our turn, the app shows 
us this information and tells us which window we should go to. The queues are managed by a server.

In my plan, the people serving at the counters would have some form of ability to manage the queue on their end. 
I wrote a makeshift website where you can connect to the server, open a counter at the selected office and matter, serve
the next numbers, and close the counter.

To test the application, you need to launch the app (requires at least iOS 16), the server, and the site for counter
management (you can also send messages to the server from the terminal using tools like wscat). If we don't want to 
run one of these things on the same machine, we obviously need to change the address from "localhost" to the 
appropriate IP address in the relevant places.

Important note! This server is an example for the Urząd Dzielnicy Ursynów, as in my plan there would be a 
separate server for each office. The app allows us to choose any office, but unless it's the Urząd Dzielnicy Ursynów,
we won't be able to join the queue there.
