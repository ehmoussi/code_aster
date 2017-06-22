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

subroutine jeliad(clas, numr, nboct)
! ROUTINE UTILISATEUR RENVOYANT LE NUMERO DE L'ENREGISTREMENT CONTENANT
!         L'OBJET SYSTEME $$RNOM DANS LE FICHIER D'ACCES DIRECT ASSOCIE
! IN  : CLAS NOM DE LA CLASSE ASSOCIEE ('G','V', ...)
! OUT : NUMR NUMERO DE L'ENREGISTREMENT
! OUT : NBOCT NOMBRE D'OCTETS STOCKES AVANT L'ENREGISTREMENT CONTENANT
!       $$RNOM
!
! ----------------------------------------------------------------------
    implicit none
#include "jeveux_private.h"
#include "asterfort/assert.h"
    character(len=*) :: clas
    integer :: numr, nboct, n
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: jcara, jdate, jhcod, jiadd, jiadm, jlong, jlono
    integer :: jltyp, jluti, jmarq
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
! ----------------------------------------------------------------------
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
! ----------------------------------------------------------------------
    character(len=1) :: kclas
    integer :: ic, lgbl
! DEB ------------------------------------------------------------------
    kclas = clas
    ic = index ( classe , kclas )
    ASSERT(ic .ne. 0)
!
!     L'OBJET $$RNOM CORRESPOND A L'INDICE 7
!
    numr = iadd(jiadd(ic)+2*7-1)
    lgbl = 1024*longbl(ic)*lois
    nboct = lgbl*(numr-1)
!
! FIN ------------------------------------------------------------------
end subroutine
