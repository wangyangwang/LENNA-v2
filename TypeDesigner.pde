//decide if headline exists //<>//
//decide headline width, font, position
//decide if paragraph exists
//decide paragraph font
//decide paragraph column number
//decide paragraph position

//draw Headline and Paragraph(s)
//return result in PGraphic object


class TypeDesigner {
    ArrayList<PFont> fonts;
    Grid myGrid;
    String details;

    TypeDesigner () {
        setupFonts();
    }

    //Main Function
    StageInfo design(Poster poster) {
        //setup variables
        PGraphics generatedTypes;
        PFont font;
        myGrid = poster.grids.get( poster.partitionArrangement.get("letters") );

        setupFonts();
        font = fonts.get(floor(random(fonts.size())));
        generatedTypes = createGraphics(myGrid.w, myGrid.h);


        getColumnNumber();
        //getHeadlineContent();
        //getParagraphContent();

        designTypography(generatedTypes, poster, font);
        applyGraphicToPoster(generatedTypes, poster);

        details = "Chose font:   "+font.getName()+"\nHeadline:   1\nParagraph:   0\nTypography Grid Width:   " + myGrid.w + "\nTypography Grid Height:   " + myGrid.h;
        StageInfo stageInfo = new StageInfo(details, generatedTypes);
        return stageInfo;
    }

    void getColumnNumber() {
    }

    private void designTypography(PGraphics pg, Poster poster, PFont font) {
        String headlineContent = getContent(1, 2).toUpperCase();
        pg.beginDraw();
        pg.fill(255);
        pg.textFont(font);
        pg.noStroke();
        pg.strokeWeight(0);
        pg.textSize(150);
        if(myGrid.h == posterHeight) {
            pg.textAlign(LEFT, BOTTOM);
            pg.text(headlineContent, 0, myGrid.h);
        }
        else{
            if (myGrid.index == 0)
            {
                pg.textAlign(LEFT, BOTTOM);
                pg.text(headlineContent, 0, myGrid.h );
            }
            else
            {
                pg.textAlign(LEFT, TOP);
                pg.text(headlineContent, 0, 0);
            }
        }
        pg.endDraw();
    }


    void applyGraphicToPoster(PGraphics pg, Poster poster) {
        poster.content.beginDraw();
        int y;
        if(myGrid.h != posterHeight){
            y = myGrid.index * poster.grids.get(0).h;
        }
        else {
            y = 0;
        }
        poster.content.image(pg, 0, y);
        poster.content.endDraw();
    }


    void setupFonts() {
        fonts = new ArrayList<PFont>();
        fonts.add(createFont("Helvetica-Bold", 500));
        fonts.add(createFont("Futura", 500));
        fonts.add(createFont("Avenir-Heavy", 500));
        fonts.add(createFont("PT-mono", 500));
    }

    void chooseFont() {
    }


    String getContent(int minWords, int maxWords) {
        JSONObject json;
        GetRequest get = new GetRequest("http://www.randomtext.me/api/gibberish/ul-1/"+minWords+"-"+maxWords);
        get.send();
        String content = get.getContent();
        try{
            json = JSONObject.parse(content);
            String text_out = json.getString("text_out");
            Document doc = Jsoup.parse(text_out);
            Elements li = doc.getElementsByTag("li");
            return li.get(0).html();
            }catch(Exception e){
                System.err.println(e);
                return "Null";
            }

        }
    }
