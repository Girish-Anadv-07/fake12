find . -not -name "*.sh" -delete
sphinx-apidoc -o . .. -T -f -M
find . -type f -name "*.rst" -exec basename {} \; | while read -r line;
do
    mkdir -p $(echo $line | sed -e 's/\./\//g' -e 's/\/rst//' -e 's/\/[^/]*$//') && touch $(echo $line | sed -e 's/\./\//g' -e 's/\/rst/.rst/')
    cp $line $(echo $line | sed -e 's/\./\//g' -e 's/\/rst/.rst/')
done
find . -type f -regex '.*\.[^.]*\.[^.]*\.[^.]*' -delete
find . -type d -empty -delete
find . -type f -name '*.rst' -exec sh -c 'sed "3,7d" "{}" > tmpfile && mv tmpfile "{}"' \;

find . -type f -name "*.rst" -exec sh -c 'sed "/Subpackages/,/^$/d" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/Submodules/,/^$/d" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "s/ module//g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "s/ package//g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/^\.\. automodule/!s/\./\//g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/^\/\/ toctree/s/\//\./g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/   /!s/.*\///g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" | while read -r line;
do
    echo $line | sed -e 's/\./\//g' -e 's/\/rst//' -e 's/\/[^/]*$//' -e 's/^..//' -e 's/\//\\\\\//g' | xargs -I {} echo "sed -i.bak 's/"{}"\///g'" $line | bash
    find . -name "*.bak" -delete
done

sphinx-quickstart