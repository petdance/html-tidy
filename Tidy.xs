#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <tidy.h>
#include <buffio.h>
#include <stdio.h>
#include <errno.h>


static void
_load_config_hash(TidyDoc tdoc, HV *tidy_options)
{
    HE *entry;

    (void) hv_iterinit(tidy_options);

    while ( (entry = hv_iternext(tidy_options)) != NULL ) {
        I32 key_len;

        const char * const key = hv_iterkey(entry,&key_len);
        const TidyOption opt = tidyGetOptionByName(tdoc,key);

        if (!opt) {
            warn( "HTML::Tidy: Unrecognized option: \"%s\"\n",key );
        }
        else {
            const TidyOptionId id   = tidyOptGetId(opt);
            SV * const sv_data      = hv_iterval(tidy_options,entry);
            STRLEN data_len;
            const char * const data = SvPV(sv_data,data_len);

            if ( ! tidyOptSetValue(tdoc,id,data) ) {
                warn( "HTML::Tidy: Can't set option: \"%s\" to \"%s\"\n", key, data );
            }
        }
    }
}
MODULE = HTML::Tidy         PACKAGE = HTML::Tidy

PROTOTYPES: ENABLE

void
_tidy_messages(input, configfile, tidy_options)
    INPUT:
        const char *input
        const char *configfile
        HV *tidy_options
    PREINIT:
        TidyBuffer errbuf = {0};
        TidyDoc tdoc = tidyCreate(); /* Initialize "document" */
        const char* newline;
        int rc = 0;
    PPCODE:
        tidyBufInit(&errbuf);
        rc = ( tidyOptSetValue( tdoc, TidyCharEncoding, "utf8" ) ? rc : -1 );

        if ( (rc >= 0 ) && configfile && *configfile ) {
            rc = tidyLoadConfig( tdoc, configfile );
        }

        if ( rc >= 0 ) {
            _load_config_hash(tdoc,tidy_options);
        }

        if ( rc >= 0 ) {
            /* Capture diagnostics */
            rc = tidySetErrorBuffer( tdoc, &errbuf );
        }

        if ( rc >= 0 ) {
            /* Parse the input */
            rc = tidyParseString( tdoc, input );
        }

        if ( rc >= 0 && errbuf.bp) {
            XPUSHs( sv_2mortal(newSVpvn((char *)errbuf.bp, errbuf.size)) );

            /* TODO: Make this a function */
            switch ( tidyOptGetInt(tdoc,TidyNewline) ) {
                case TidyLF:
                    newline = "\n";
                    break;
                case TidyCR:
                    newline = "\r";
                    break;
                default:
                    newline = "\r\n";
                    break;
            }
            XPUSHs( sv_2mortal(newSVpv(newline, 0)) );
        }
        else {
            rc = -1;
        }

        if ( errbuf.bp )
            tidyBufFree( &errbuf );
        tidyRelease( tdoc );

        if ( rc < 0 ) {
            XSRETURN_UNDEF;
        }


void
_tidy_clean(input, configfile, tidy_options)
    INPUT:
        const char *input
        const char *configfile
        HV *tidy_options
    PREINIT:
        TidyBuffer errbuf = {0};
        TidyBuffer output = {0};
        TidyDoc tdoc = tidyCreate(); /* Initialize "document" */
        const char* newline;
        int rc = 0;
    PPCODE:
        tidyBufInit(&output);
        tidyBufInit(&errbuf);
        /* Set our default first. */
        /* Don't word-wrap */
        rc = ( tidyOptSetInt( tdoc, TidyWrapLen, 0 ) ? rc : -1 );

        if ( (rc >= 0 ) && configfile && *configfile ) {
            rc = tidyLoadConfig( tdoc, configfile );
        }

        /* XXX I think this cascade is a bug waiting to happen */

        if ( rc >= 0 ) {
            rc = ( tidyOptSetValue( tdoc, TidyCharEncoding, "utf8" ) ? rc : -1 );
        }

        if ( rc >= 0 ) {
            _load_config_hash( tdoc, tidy_options );
        }

        if ( rc >= 0 ) {
            rc = tidySetErrorBuffer( tdoc, &errbuf );  // Capture diagnostics
        }

        if ( rc >= 0 ) {
            rc = tidyParseString( tdoc, input );   // Parse the input
        }

        if ( rc >= 0 ) {
            rc = tidyCleanAndRepair(tdoc);
        }

        if ( rc > 1 ) {
            rc = ( tidyOptSetBool( tdoc, TidyForceOutput, yes ) ? rc : -1 );
        }

        if ( rc >= 0) {
            rc = tidySaveBuffer( tdoc, &output );
        }

        if ( rc >= 0) {
            rc = tidyRunDiagnostics( tdoc );
        }

        if ( rc >= 0 && output.bp && errbuf.bp ) {
            XPUSHs( sv_2mortal(newSVpvn((char *)output.bp, output.size)) );
            XPUSHs( sv_2mortal(newSVpvn((char *)errbuf.bp, errbuf.size)) );

            /* TODO: Hoist this into a function */
            switch ( tidyOptGetInt(tdoc,TidyNewline) ) {
                case TidyLF:
                    newline = "\n";
                    break;
                case TidyCR:
                    newline = "\r";
                    break;
                default: 
                    newline = "\r\n";
                    break;
            }
            XPUSHs( sv_2mortal(newSVpv(newline, 0)) );
        }
        else {
            rc = -1;
        }

        tidyBufFree( &output );
        tidyBufFree( &errbuf );
        tidyRelease( tdoc );

        if ( rc < 0 ) {
            XSRETURN_UNDEF;
        }


SV*
_tidy_release_date()
    PREINIT:
        const char* version;
    CODE:
        version = tidyReleaseDate();
        RETVAL = newSVpv(version,0); /* will be automatically "mortalized" */
    OUTPUT:
        RETVAL
