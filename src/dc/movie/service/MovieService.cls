Class dc.movie.service.MovieService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// Return all the records
ClassMethod GetAllMovies() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.movie.model.Movie).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Write "["
    
    if rset.%Next() {
        Set movie = ##class(dc.movie.model.Movie).%OpenId(rset.ID)    
        Do movie.%JSONExport()
    }
    
    While rset.%Next() {   
        Write "," 
        Set movie = ##class(dc.movie.model.Movie).%OpenId(rset.ID)    
        Do movie.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record
ClassMethod GetMovie(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set movie = ##class(dc.movie.model.Movie).%OpenId(id)

    If '$IsObject(movie) Quit ..Http404()

    Do movie.%JSONExport()

    Quit tSC
}

/// Creates a new record
ClassMethod CreateMovie() As %Status
{
	
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set movie = ##class(dc.movie.model.Movie).%New()

    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,movie.%JSONImport(data))
    $$$TOE(tSC,movie.%Save())

    Write movie.%JSONExport()

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Quit tSC
}

/// Update a record with id
ClassMethod UpdateMovie(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK 
    #dim e As %Exception.AbstractException
    
    Set movie = ##class(dc.movie.model.Movie).%OpenId(id) 
    
    If '$IsObject(movie) Return ..Http404()
    
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,movie.%JSONImport(data))
    $$$TOE(tSC,movie.%Save())
    
    Write movie.%JSONExport()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Delete a record with id
ClassMethod DeleteMovie(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set movie = ##class(dc.movie.model.Movie).%OpenId(id)
    
    If '$IsObject(movie) Return ..Http404()

    $$$TOE(tSC, movie.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Return all the records
ClassMethod GetMovieCasting(id As %Integer) As %Status
{

    #dim tSC As %Status = $$$OK

    Set qry = "SELECT actor->name AS actorName, characterName, movie->name AS movieName FROM dc_movie_model.Casting WHERE movie = ?"

    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute(id)
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.actorName = rset.actorName
        Set item.movieName = rset.movieName
        Set item.characterName = rset.characterName
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

}
