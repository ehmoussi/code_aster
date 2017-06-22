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

subroutine jxlirb(ic, iaddi, iadmo, lso)
! person_in_charge: j-pierre.lefebvre at edf.fr
! aslint: disable=W1303
! for the path name
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterc/readdr.h"
#include "asterfort/codent.h"
#include "asterfort/get_jvbasename.h"
#include "asterfort/utmess.h"
    integer :: ic, iaddi, iadmo, lso
! ----------------------------------------------------------------------
! LECTURE D'UN BLOC DU FICHIER D'ACCES DIRECT ASSOCIE A UNE BASE
!
!
! IN  IC    : CLASSE ASSOCIEE
! IN  IADDI : ADRESSE DISQUE
! IN  IADMO : ADRESSE MEMOIRE EN OCTETS
! IN  LSO   : LONGUEUR EN OCTETS
! ----------------------------------------------------------------------
!
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!     ------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iadloc, ierr, jiacce, jiecr, n
    integer :: nbacce, nblent, numext
!-----------------------------------------------------------------------
    parameter      ( n = 5 )
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &                 kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &                 iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    character(len=128) :: repglo, repvol
    common /banvje/  repglo,repvol
    integer :: lrepgl, lrepvo
    common /balvje/  lrepgl,lrepvo
    integer :: idn, iext, nbenrg
    common /iextje/  idn(n) , iext(n) , nbenrg(n)
    common /jiacce/  jiacce(n),nbacce(2*n)
!     ------------------------------------------------------------------
    aster_logical :: lrab
    character(len=512) :: nom512
    integer :: lgbl, vali(3)
! DEB ------------------------------------------------------------------
    ierr = 0
    lgbl = 1024*longbl(ic)*lois
    nblent = lso / lgbl
    lrab = ( mod (lso,lgbl) .ne. 0 )
!
    do 10 i = 1, nblent
        numext = (iaddi+i-2)/nbenrg(ic)
        iadloc = (iaddi+i-1)-(numext*nbenrg(ic))
        call get_jvbasename(nomfic(ic)(1:4), numext + 1, nom512)
        jiecr = (jk1zon+iadmo-1+lgbl*(i-1))/lois+1
        call readdr(nom512, iszon(jiecr), lgbl, iadloc, ierr)
        if (ierr .ne. 0) then
            vali(1) = iaddi+i-1
            vali(2) = numext
            vali(3) = ierr
            call utmess('F', 'JEVEUX_41', sk=nombas(ic), ni=3, vali=vali)
        endif
        nbacce(2*ic-1) = nbacce(2*ic-1) + 1
 10 continue
    iacce (jiacce(ic)+iaddi)=iacce(jiacce(ic)+iaddi) + 1
    if (lrab) then
        numext = (iaddi+nblent-1)/nbenrg(ic)
        iadloc = (iaddi+nblent)-(numext*nbenrg(ic))
        call get_jvbasename(nomfic(ic)(1:4), numext + 1, nom512)
        jiecr = (jk1zon+iadmo-1+lso-lgbl)/lois+1
        if (lso .lt. lgbl) then
            jiecr = (jk1zon+iadmo-1)/lois+1
        endif
        call readdr(nom512, iszon(jiecr), lgbl, iadloc, ierr)
        if (ierr .ne. 0) then
            vali(1) = iaddi+i-1
            vali(2) = numext
            vali(3) = ierr
            call utmess('F', 'JEVEUX_41', sk=nombas(ic), ni=3, vali=vali)
        endif
        nbacce(2*ic-1) = nbacce(2*ic-1) + 1
    endif
! FIN ------------------------------------------------------------------
end subroutine
