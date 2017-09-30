#include <sstream>
#include <iomanip>

class ResultNaming
{
public:
    // up to 4294967295 objects can be base 16 encoded on 8 chars.
    static int numberOfObjects;

    static std::string getCurrentName()
    {
        std::stringstream sstream;
        sstream << std::setfill ('0') << std::setw(8) << std::hex
                << ResultNaming::numberOfObjects;
        return sstream.str();
    }

    static std::string getNewResultName()
    {
        numberOfObjects += 1;
        return getCurrentName();
    }
};
