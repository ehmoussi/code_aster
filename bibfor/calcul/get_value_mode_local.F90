! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine get_value_mode_local(nmparz, listepara, valepara, iret, retpara_, nbpara_, itab_)

use calcul_module, only :   ca_caindz_, ca_capoiz_, ca_iaoppa_, &
                            ca_iawlo2_, ca_iawloc_, ca_iel_,    &
                            ca_igr_,    ca_nbgr_,   ca_nomte_,  &
                            ca_nparin_, ca_npario_, ca_option_, &
                            ca_iaopds_, ca_iadsgd_, &
                            ca_iamloc_, ca_ilmloc_, ca_iachii_, ca_iachid_
!
implicit none
!
    character(len=*),   intent(in)   :: nmparz
    character(len=8),   intent(in)   :: listepara(:)
    real(kind=8),       intent(out)  :: valepara(:)
    integer,            intent(out)  :: iret
    integer, optional,  intent(out)  :: retpara_(:)
    integer, optional,  intent(in)   :: nbpara_
    integer, optional,  intent(out)  :: itab_
!
! --------------------------------------------------------------------------------------------------
!
!  Entrées
!       nompar          : nom du paramètre de l'option
!       listepara(i)    : noms des paramètres
!       nbpara_         : nombre de paramètre
!
!  Sorties
!       valepara(i)     : valeurs des paramètres
!       iret            : nombre d'erreur si 0 : OK
!       retpara_(i)     : code d'erreur si 0 : OK
!                           si 1 : le paramètre n'est pas dans la carte ==> valepara(i) = Nan
!       itab_           : adresse du champ local correspondant à nompar
!
! --------------------------------------------------------------------------------------------------
!
! person_in_charge: jean-luc.flejou at edf.fr
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/chloet.h"
#include "asterfort/contex_param.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/rgcmpg.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii, ii1,ii2, jj, kk, npari2, nbec, imodat, imodloc, nbscalmloc, itab
    integer :: iparg, debugr, iachlo, ilchlo, lgcata, iopt, igd, nbin, inomcp, iaopd2
    integer :: jceld, adiel, debgr2, decael, lonchl, iapara, itrou, nbcmp, iaoplo, iadgd
    integer :: iposimloc, iposicarte
!
    real(kind=8)        :: rundf
    character(len=8)    :: nompar
    character(len=24)   :: valk(5)
!
    aster_logical       :: etendu, oknompar, lretpara
!
    integer, parameter  :: maxentiercode = 5
    integer             :: entiercode(maxentiercode)
! --------------------------------------------------------------------------------------------------
!
!   Le code ci-dessous est une copie des 1ères lignes de : "jevech"
    nompar  = nmparz
!   Recherche de la chaîne nompar avec mémoire sur tout 'calcul'
    ca_capoiz_ = ca_capoiz_ + 1
    if (ca_capoiz_ .gt. 512) then
        iparg = indik8(zk8(ca_iaoppa_),nompar,1,ca_npario_)
    else
        if (zk8(ca_iaoppa_-1+ca_caindz_(ca_capoiz_)) .eq. nompar) then
            iparg = ca_caindz_(ca_capoiz_)
        else
            iparg = indik8(zk8(ca_iaoppa_),nompar,1,ca_npario_)
            ca_caindz_(ca_capoiz_) = iparg
        endif
    endif
!   On ne trouve pas le paramètre dans les options de calcul
    if (iparg .eq. 0) then
        valk(1) = nompar
        valk(2) = ca_option_
        call utmess('E', 'CALCUL_15', nk=2, valk=valk)
        call contex_param(ca_option_, ' ')
    endif
!   Les paramètres "in"
!       donc si iparg > nombre de paramètre "in" ==> c'est pas bon
    if (iparg.gt.ca_nparin_) then
        write(6,*) nompar,' est un paramètre "out" et pas "in".'
        ASSERT(.false.)
    endif
    iachlo=zi(ca_iawloc_-1+3*(iparg-1)+1)
    ilchlo=zi(ca_iawloc_-1+3*(iparg-1)+2)
!   Décalage sur le mode local
    imodat=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+1)
!   Nombre de grandeur dans le mode local
    lgcata=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+2)
!   Adresse des valeurs dans le mode local
    debugr=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+5)
!
!   Code issue de "tecach"
!   le champ n'existe pas (globalement)
!       cela peut être normal si pas d'affectation
!       on retourne Nan pour tous les paramètres
    if (iachlo .eq. -1) then
        rundf    = r8nnem()
        lretpara = present(retpara_)
        iret = 0
        if ( present(nbpara_) ) then
            ii1=1; ii2=nbpara_
        else
            ii1=lbound(listepara,1); ii2=ubound(listepara,1)
        endif
        do ii = ii1, ii2
            valepara(ii) = rundf
            if ( lretpara ) retpara_(ii) = 1
            iret = iret + 1
        enddo
        goto 999
    endif
    ASSERT(iachlo.ne.-2)
!
!   Si un problème dans le catalogue du paramètre
!       le parametre n'existe pas pour l'élément
!       C'est une erreur développeur dans les catalogues
    if (lgcata .eq. -1) then
        valk(1) = nompar
        valk(2) = ca_option_
        valk(3) = ca_nomte_
        call utmess('E', 'CALCUL_16', nk=3, valk=valk)
        call contex_param(ca_option_, nompar)
    endif
!
!   Calcul de itab, lonchl, decael
    call chloet(iparg, etendu, jceld)
    if ( etendu ) then
        adiel  = zi(jceld-1+zi(jceld-1+4+ca_igr_)+4+4*(ca_iel_-1)+4)
        debgr2 = zi(jceld-1+zi(jceld-1+4+ca_igr_)+8)
        ASSERT(lgcata.eq.zi(jceld-1+zi(jceld-1+4+ca_igr_)+3))
        decael = (adiel-debgr2)
        lonchl = zi(jceld-1+zi(jceld-1+4+ca_igr_)+4+4*(ca_iel_-1)+3)
    else
        decael = (ca_iel_-1)*lgcata
        lonchl = lgcata
    endif
    itab = iachlo+debugr-1+decael
    if ( present( itab_ ) ) then
        itab_ = itab
    endif
!
! --------------------------------------------------------------------------------------------------
!
!   LES LIGNES CI-DESSOUS SONT NOUVELLES PAR RAPPORT A JEVECH
!
!   On va chercher:
!       - les para_in et para_out de l'option
!       - la grandeur dans l'option
!       - nombre et nom des composantes dans la grandeur
! --------------------------------------------------------------------------------------------------
!
!   Pointeur sur l'option                       ==> ca_iaopds_
!   Pointeur sur les paramètres de l'option     ==> ca_iaoppa_
    nbin = zi(ca_iaopds_-1+2)
!     nbou = zi(ca_iaopds_-1+3)
!   L'ordre de la grandeur dans les paramètres in, pas dans out
    itrou = indik8(zk8(ca_iaoppa_),nompar,1,nbin)
    ASSERT( itrou .gt. 0)
    igd   = zi(ca_iaopds_-1+4+itrou)
!   Adresse des grandeurs  ==> ca_iadsgd_
    iadgd = ca_iadsgd_+7*(igd-1)
!   Une petite vérif
    ASSERT( zi(iadgd).le.3 )
!   Nombre d'entier codé de la grandeur
    nbec = zi(iadgd-1+3)
!   Adresse du mode local
    imodloc = ca_iamloc_ - 1 + zi(ca_ilmloc_-1+imodat)
!   Entiers codés du mode local
    ASSERT( nbec .le. maxentiercode )
    do ii = 1, nbec
        entiercode(ii) = zi(imodloc-1+4+ii)
    enddo
!   Nombre de scalaires représentant la grandeur pour le mode_local
    nbscalmloc = zi(imodloc-1+3)
!   Nombre et nom des composantes dans la grandeur
!       Recherche  dans les paramètres in de la grandeur
    nbcmp=0; inomcp=0
    doii1: do ii = 1 , nbin
        if ( zi(ca_iachii_-1+ca_iachid_*(ii-1)+1) .eq. igd ) then
!             nbec   = zi(ca_iachii_-1+ca_iachid_*(ii-1)+2)
            nbcmp  = zi(ca_iachii_-1+ca_iachid_*(ii-1)+3)
            inomcp = zi(ca_iachii_-1+ca_iachid_*(ii-1)+12)
            exit doii1
        endif
    enddo doii1
    ASSERT( (nbcmp.ne.0).and.(inomcp.ne.0) )
!
    rundf    = r8nnem()
    lretpara = present(retpara_)
    iret = 0
    if ( present(nbpara_) ) then
        ii1=1; ii2=nbpara_
    else
        ii1=lbound(listepara,1); ii2=ubound(listepara,1)
    endif
    do ii = ii1, ii2
!       Recherche la position du paramètre dans la carte
        iposicarte = indik8(zk8(inomcp),listepara(ii), 1, nbcmp )
        ASSERT( iposicarte.ne.0 )
!       Recherche la position du paramètre dans l'entier codé
        dokk1: do kk = 1 , nbec
            iposimloc = rgcmpg( entiercode(kk), iposicarte )
            if ( iposimloc .ne. 0 ) exit dokk1
        enddo dokk1
        ASSERT( (iposimloc.ge.1).and.(iposimloc.le.lonchl) )
!       Si le paramètre a été ajouté à la carte lors de sa création
        if ( zl(ilchlo+debugr-1+decael+iposimloc-1) ) then
            valepara(ii) = zr(itab-1+iposimloc)
            if ( lretpara ) retpara_(ii) = 0
        else
            valepara(ii) = rundf
            if ( lretpara ) retpara_(ii) = 1
            iret = iret + 1
!             write(*,*) "La composante ", listepara(ii), " n'est pas renseignée dans le mode local"
!             ASSERT( .false. )
        endif
    enddo
999 continue
end subroutine
