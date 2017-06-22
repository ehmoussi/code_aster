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

subroutine jereou(clas, pcent)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterc/rmfile.h"
#include "asterfort/assert.h"
#include "asterfort/jeinif.h"
#include "asterfort/jelibf.h"
#include "asterfort/lxmins.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: clas
    real(kind=8), intent(in) :: pcent
! ----------------------------------------------------------------------
! ROUTINE UTILISATEUR PERMETTANT DE FERMER UNE BASE, DE DETRUIRE LE OU
!         LES FICHIERS ASSOCIES ET DE LA RE-OUVRIR
! IN : CLAS  NOM DE LA CLASSE ASSOCIEE ('G','V', ...)
! IN : PCENT POURCENTAGE EN TERME DE NOMBRE D'ENREGISTREMENTS OCCUPES
!            AU-DELA DUQUEL ON DECLENCHE LA DESTRUCTION
!
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: n
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &                 kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &                 iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
!
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
! DEB ------------------------------------------------------------------
    character(len=1) :: klas
    character(len=8) :: kstin, kstou, nom, nomb
    integer :: ic, nrep, lbloc, nbloc, info, vali(3)
    real(kind=8) :: valr(2)
!
    klas = clas
    ASSERT(klas .ne. ' ')
    ic = index (classe , klas)
!
    nomb = nombas(ic)
    nom = nomb(1:4)//'.?  '
    nrep = nremax(ic)
    lbloc = longbl(ic)
    nbloc = nblmax(ic)
    kstin = kstini(ic)
    kstou = kstout(ic)
!
    if (nbluti(ic) .gt. pcent*nblmax(ic)) then
        valr (1) = 100.d0*nbluti(ic)/nblmax(ic)
        valr (2) = 100.d0*pcent
        vali (1) = nbluti(ic)
        vali (2) = nint(nbluti(ic)*longbl(ic)*lois/1024.d0)
        vali (3) = nblmax(ic)
        call utmess('I', 'JEVEUX_63', sk=nombas(ic), ni=3, vali=vali,&
                    nr=2, valr=valr)
        info = 0
        call jelibf('DETRUIT', klas, info)
        call lxmins(nom)
        call rmfile(nom, 0)
        call jeinif(kstin, kstou, nomb, klas, nrep,&
                    nbloc, lbloc)
    endif
!
end subroutine
