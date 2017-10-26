! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine jjagod(iclas, nblnew)
! person_in_charge: j-pierre.lefebvre at edf.fr
! aslint: disable=C1002
    implicit none
#include "asterfort/assert.h"
#include "jeveux_private.h"
#include "asterfort/jjalls.h"
#include "asterfort/jjecrs.h"
#include "asterfort/jjldyn.h"
#include "asterfort/jjlidy.h"
#include "asterfort/jxecro.h"
#include "asterfort/jxlibd.h"
#include "asterfort/utmess.h"
    integer, intent(in) :: iclas, nblnew
! ----------------------------------------------------------------------
!     PERMET D'AGRANDIR LES OBJETS SYSTEME ASSOCIES AUX ENREGISTREMENTS
!     ADRESSE DISQUE ($$IUSADI) ET NOMBRE D'ACCES ($$ACCE)
!
!     IN    ICLAS  : CLASSE ASSOCIEE AU REPERTOIRE
!     IN    NBLNEW : NOUVELLE TAILLE DES OBJETS 
!
! ----------------------------------------------------------------------
    integer :: n
    integer :: igenr(1), itype(1), idocu(1), iorig(1), irnom(4)
    equivalence      (igenr,genr),(itype,type),&
     &                 (idocu,docu),(iorig,orig),(irnom,rnom)
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!-----------------------------------------------------------------------
    integer :: ic, jusadi, jiacce, nbacce
    integer :: ipgca, jcara, jdate, jdocu, jtype
    integer :: jgenr, jhcod, jiadd, jiadm, jindir, jlong
    integer :: jlono, jltyp, jluti, jmarq, jorig, jrnom
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &               jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
! ----------------------------------------------------------------------
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &               kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &               iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    common /jindir/  jindir(n)
    common /jusadi/  jusadi(n)
    common /jiacce/  jiacce(n),nbacce(2*n)
!
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,  lgp,lgputi
    integer :: ldyn, lgdyn, nbdyn, nbfree
    common /idynje/  ldyn , lgdyn , nbdyn , nbfree
    integer :: indiq_jjldyn
    common /idynqq/ indiq_jjldyn
    integer :: indiq_jjagod
    common /idagod/ indiq_jjagod
! ----------------------------------------------------------------------
    integer :: iad14, kat14, kdy14, iad15, kat15, kdy15, ldynol, l
    integer :: lon, lonoi, irt, iadmi, iadyn, imq(2)
! DEB ------------------------------------------------------------------
    ic = iclas
    ASSERT ( nblnew .gt. nblmax(ic) )
    ipgca = ipgc
    ipgc = -2
    irt = 0
    indiq_jjagod = 1
!
! --- ON INTERDIT L'APPEL A JJLDYN AVEC LE PARAMETRE MODE=1 LORS DE
! --- L'ALLOCATION DYNAMIQUE  (ET LES APPELS RECURSIFS)
!
    ldynol = ldyn
    if (ldyn .eq. 1) then
       ldyn = 2
    endif
!
! --- ALLOCATION DU SEGMENT DE VALEURS POUR LE NOUVEL OBJET USADI (14) ET 
! --- RECOPIE DU CONTENU DE L'ANCIEN OBJET
!
    lon = 3*nblnew*lois
    call jjalls(lon, ic, 'V', 'I', lois, 'INIT', iusadi, iad14, kat14, kdy14)
    do  l = 1, nblnew
        iusadi(iad14 + (3*l-2) - 1) = -1
        iusadi(iad14 + (3*l-1) - 1) = -1
        iusadi(iad14 + (3*l)   - 1) =  0
    enddo
    do l = 1, 3*nblmax(ic)
        iusadi(iad14 + l - 1) = iusadi(jusadi(ic)+l)
    enddo

    iadmi=iadm(jiadm(ic)+2*14-1)
    iadyn=iadm(jiadm(ic)+2*14)
    call jjecrs(kat14, ic, 14, 0, 'E', imq)
    jusadi(ic) = iad14 - 1 
    long(jlong(ic)+14) = 3*nblnew
    lono(jlono(ic)+14) = 3*nblnew
    iadm(jiadm(ic)+2*14-1) = kat14
    iadm(jiadm(ic)+2*14 )  = kdy14
!
! --- L'ANCIENNE IMAGE DE L'OBJET PEUT ETRE MARQUEE INUTILISEE
!
    if (iadd(jiadd(ic)+2*14-1) .gt. 0) then
        lonoi = lono(jlono(ic)+14)*ltyp(jltyp(ic)+14)
        call jxlibd(0, 14, ic, iadd(jiadd(ic)+2*14-1), lonoi)
        iadd(jiadd(ic)+2*14-1) = 0
        iadd(jiadd(ic)+2*14 ) = 0
    endif
!
! --- L'ANCIEN OBJET PEUT ETRE DETRUIT
!
    call jjlidy(iadyn,iadmi)
!
! --- ALLOCATION DU SEGMENT DE VALEURS POUR LE NOUVEL OBJET IACCE (15) ET 
! --- RECOPIE DU CONTENU DE L'ANCIEN OBJET
!
    lon = nblnew*lois
    call jjalls(lon, ic, 'V', 'I', lois, 'INIT', iacce, iad15, kat15, kdy15)
    do l = 1, nblmax(ic)
        iacce(iad15 + l) = iacce(jiacce(ic) + l)
    enddo

    iadmi=iadm(jiadm(ic)+2*15-1)
    iadyn=iadm(jiadm(ic)+2*15)
    call jjecrs(kat15, ic, 15, 0, 'E', imq)
    jiacce(ic) = iad15 - 1
    long(jlong(ic)+15) = nblnew
    lono(jlono(ic)+15) = nblnew
    iadm(jiadm(ic)+2*15-1) = kat15
    iadm(jiadm(ic)+2*15 )  = kdy15

!
! --- L'ANCIEN OBJET PEUT ETRE DETRUIT
!
    call jjlidy(iadyn,iadmi)
!
! --- L'ANCIENNE IMAGE DE L'OBJET PEUT ETRE MARQUEE INUTILISEE
!
    if (iadd(jiadd(ic)+2*15-1) .gt. 0) then
        lonoi = lono(jlono(ic)+15)*ltyp(jltyp(ic)+15)
        call jxlibd(0, 15, ic, iadd(jiadd(ic)+2*15-1), lonoi)
        iadd(jiadd(ic)+2*15-1) = 0
        iadd(jiadd(ic)+2*15 ) = 0
    endif
!
    nblmax(ic)=nblnew
!
    ldyn = ldynol
    ipgc = ipgca
    indiq_jjagod = 0 
! FIN ------------------------------------------------------------------
end subroutine
