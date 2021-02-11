/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
 
 void clean_buf();
 int close_comment_stack = 0; /* to handle nested comments */
 int len_string;

%}

/*
 * Define names for regular expressions here.
 */

DARROW          =>

delim         [ \n\f\t\v\r]
ws            {delim}+
digit         [0-9]
letter        [A-Za-z]
part_id       [A-Za-z0-9_]
number        {digit}+
lower         [a-z]
upper         [A-Z]
type_id       {upper}{part_id}*
object_id     {lower}{part_id}*
symbol        [\.\;\,\+\-\*\/\~\(\)\{\}\=\@\<\:]

%x STRING
%x ESC_CHAR
%x DASH_COM
%x NESTED_COM
%x RESUM_STRING

     
%%

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
(?i:class)  { return (CLASS); }
(?i:else)    { return (ELSE); }
(?i:fi)      { return (FI); }
(?i:if)      { return (IF); }
(?i:in)      { return (IN); }
(?i:inherits) { return (INHERITS); }
(?i:isvoid) { return(ISVOID); }
(?i:let) { return (LET); }
(?i:loop) { return (LOOP); }
(?i:pool) { return (POOL); }
(?i:then) { return (THEN); }
(?i:while) { return (WHILE); }
(?i:case) { return (CASE); }
(?i:esac) { return (ESAC); } 
 (?i:new) { return (NEW); }
(?i:of) { return (OF); }
(?i:not) { return (NOT); }
t(?i:rue) { cool_yylval.boolean = true; return (BOOL_CONST); }
f(?i:alse) { cool_yylval.boolean = false; return (BOOL_CONST); }

"<=" { return (LE); }
"<-" { return (ASSIGN); }
{symbol} { return yytext[0]; }



{number} {
    cool_yylval.symbol = inttable.add_string(yytext);
    return (INT_CONST);
}
{type_id} {
    cool_yylval.symbol = stringtable.add_string(yytext);
    return (TYPEID);
}
{object_id} {
    cool_yylval.symbol = stringtable.add_string(yytext);
    return (OBJECTID);
}
    /* **************** Beginning of string lexing *************** */

\" {
    string_buf_ptr = string_buf;
    len_string = 0; 
    BEGIN(STRING); }

<STRING>\"  {
    cool_yylval.symbol = stringtable.add_string(string_buf_ptr);
    clean_buf();
    BEGIN(INITIAL);
    return STR_CONST;
}
<STRING>\n {
    cool_yylval.error_msg = "Unterminated string constant";
    clean_buf();
    curr_lineno++;
    return ERROR;
}
<STRING>\0 {
    cool_yylval.error_msg = "String contains null character";
    clean_buf();
    BEGIN(RESUM_STRING);
    return ERROR;
}
<STRING><<EOF>> {
    cool_yylval.error_msg = "EOF in string constant";
    clean_buf();
    BEGIN(INITIAL);
    return ERROR;
}
<STRING>. {
    ++len_string;
    if(len_string + 1 >= MAX_STR_CONST){
        cool_yylval.error_msg = "String constant too long";
        BEGIN(RESUM_STRING);
        return ERROR;
    } else {
        strcat(string_buf, yytext);
    }
}
<RESUM_STRING>\" {
    BEGIN(INITIAL);
}
<RESUM_STRING>\n {
    curr_lineno++;
    BEGIN(INITIAL);
}
    /* if the new line is escaped we still inside the string */
<RESUM_STRING>\\\n {
    curr_lineno++;
}
<RESUM_STRING>. {}

    /* ***************** Dashed comments *********************** */

"--" { BEGIN(DASH_COM); }

<DASH_COM>\n {
    curr_lineno++;
    BEGIN(INITIAL);
}
<DASH_COM><<EOF>> {
    BEGIN(INITIAL);
}
<DASH_COM>. {}

    /* ************** Nested comments ********************** */

"(*" {
    BEGIN(NESTED_COM);
    ++close_comment_stack;
}
<NESTED_COM>"(*" {
    ++close_comment_stack;
}
<NESTED_COM>"*)" {
    --close_comment_stack;
    if(close_comment_stack == 0)
        BEGIN(INITIAL);
}
<NESTED_COM>\n {
    curr_lineno++;
}
<NESTED_COM><<EOF>> {
    BEGIN(INITIAL);
}
<NESTED_COM>.  {}

"*)" {
    cool_yylval.error_msg = "Unmatched *)";
    return ERROR;
}

    /* **************** others ************ */

\n    { curr_lineno++; }

{ws}  {} 
.   {
    cool_yylval.error_msg = yytext;
    return (ERROR); 
} 

%%

void clean_buf(){
    *string_buf_ptr = '\0';
}
