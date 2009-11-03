#define PERL_NO_GET_CONTEXT
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "ppport.h"

static UV
strtab_refcount(pTHX_ HE* const he){
#if PERL_BCDVERSION >= 0x5010000
    return (UV)he->he_valu.hent_refcount;
#else
    return (UV)( PTR2UV(HeVAL(he)) / sizeof(SV*) );
#endif
}


MODULE = B::Shared    PACKAGE = B::Shared

PROTOTYPES: DISABLE

void
dump(SV* filename = NULL, bool display_refcount = 1)
PREINIT:
    HV* const hv      = PL_strtab;
    HE* iter;
    AV* keys = newAV();
    I32 len;
    I32 i;
    PerlIO* out;
CODE:
    if(filename && SvOK(filename)){
        out = PerlIO_open(SvPV_nolen_const(filename), "w");
        if(!out){
            Perl_croak(aTHX_ "Cannot open '%"SVf"': %"SVf, filename, get_sv("!", GV_ADD));
        }
    }
    else{
        out = PerlIO_stdout();
    }

    hv_iterinit(hv);
    while((iter = hv_iternext(hv))){
        SV* const key = hv_iterkeysv(iter);
        av_push(keys, key);
        SvREFCNT_inc_simple_void_NN(key);
    }
    len = AvFILLp(keys)+1;
    sortsv(AvARRAY(keys), len, Perl_sv_cmp);

    for(i = 0; i < len; i++){
        SV* const key = AvARRAY(keys)[i];

        iter = hv_fetch_ent(hv, key, FALSE, 0U);

        if(SvUTF8(key)){
            PerlIO_write(out, SvPVX(key), SvCUR(key));
        }
        else{
            const char* pv  = SvPV_nolen_const(key);
            const char* end = SvEND(key);
            while(pv != end){
                if(isCNTRL(*pv)){
                    STDCHAR const c = toCTRL(*pv);
                    PerlIO_write(out, "^", 1);
                    PerlIO_write(out, &c, 1);
                }
                else if(isPRINT(*pv)){
                    PerlIO_write(out, pv, 1);
                }
                else{
                    PerlIO_printf(out, "\\x%02x", (unsigned)*pv);
                }
                pv++;
            }
        }

        if(display_refcount){
            PerlIO_printf(out, " = %"UVuf"\n", strtab_refcount(aTHX_ iter));
        }
        else{
            PerlIO_printf(out, "\n");
        }
    }
    SvREFCNT_dec(keys);

    if(filename && SvOK(filename)){
        PerlIO_close(out);
    }

SV*
new_str(SV* sv)
PREINIT:
    const char* pv;
    STRLEN len;
CODE:
    pv = SvPV_const(sv, len);
    RETVAL = newSVpvn(pv, len);
OUTPUT:
    RETVAL

SV*
new_shared_str(SV* sv)
PREINIT:
    const char* pv;
    STRLEN len;
CODE:
    pv = SvPV_const(sv, len);
    RETVAL = newSVpvn_share(pv, len, 0U);
OUTPUT:
    RETVAL
