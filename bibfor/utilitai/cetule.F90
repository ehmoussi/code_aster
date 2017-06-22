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

subroutine cetule(model0, tbgrca, codret)
! GRANDEURS CARACTERISTIQUES DE L'ETUDE - LECTURE
!           *                     ***     **
!     ------------------------------------------------------------------
!      RECUPERATION DES GRANDEURS CARACTERISTIQUES CONTENUES
!      DANS LE MODELE
!      QUAND ELLES SONT FOURNIES, CES GRANDEURS SONT > 0
!      PAR DEFAUT, ON MET DONC DES VALEURS NEGATIVES POUR TESTER ENSUITE
!      REMARQUE : LES GRANDEURS SONT STOCKEES PAR LE SP CETUCR
!
! IN  : MODELE  : NOM DE LA SD MODELE
! OUT : TBGRCA  : TABLEAU DES GRANDEURS CARACTERISTIQUES AVEC LA
!                 CONVENTION SUIVANTE :
!                 1 : LONGUEUR
!                 2 : PRESSION
!                 3 : TEMPERATURE
! OUT : CODRET  : 0 : OK
!                 1 : LA TABLE N'EXISTE PAS
!                 2 : UN DES PARAMETRES EST DEFINI 0 OU PLUSIEURS FOIS
!     ------------------------------------------------------------------
!
    implicit   none
!
! DECLARATION PARAMETRES
!
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbliva.h"
    integer :: nbmcle
    parameter  ( nbmcle = 3 )
!
! DECLARATION PARAMETRES D'APPELS
! -------------------------------
    character(len=*) :: model0
    real(kind=8) :: tbgrca(nbmcle)
    integer :: codret
!     ------------------------------------------------------------------
!
! DECLARATION VARIABLES LOCALES
!
    integer :: ibid, iaux, vali, iret
!
    real(kind=8) :: valeur, rbid
!
    complex(kind=8) :: cbid, valc
!
    character(len=1) :: ctype
    character(len=8) :: nomgrd(nbmcle)
    character(len=8) :: modele
    character(len=8) :: kbid, valk
    character(len=19) :: table
!
!     ------------------------------------------------------------------
    data nomgrd / 'LONGUEUR', 'PRESSION', 'TEMP' /
!     ------------------------------------------------------------------
!
    call jemarq()
    ibid=0
    rbid=0.d0
    cbid=(0.d0,0.d0)
!
    modele = model0(1:8)
!
!====
! 1. VALEURS PAR DEFAUT (R8VIDE ? VOIR TE0500)
!====
!
    do 10 , iaux = 1 , nbmcle
    tbgrca(iaux) = -1.d0
    10 end do
!
!====
! 2. REPERAGE DE LA TABLE
!====
!
    call jeexin(modele//'           .LTNT', iret)
    if (iret .ne. 0) then
        call ltnotb(modele, 'CARA_ETUDE', table)
        codret = 0
    else
        codret = 1
    endif
!
!====
! 3. DECODAGE DE LA TABLE
!====
!
    if (codret .eq. 0) then
!
        do 30 , iaux = 1 , nbmcle
!
        call tbliva(table, 1, 'GRANDEUR', [ibid], [rbid],&
                    [cbid], nomgrd( iaux), kbid, [rbid], 'VALE',&
                    ctype, vali, valeur, valc, valk,&
                    iret)
!
        if (iret .eq. 0) then
!
            tbgrca(iaux) = valeur
!
        else if (iret.ge.2) then
!
            codret = 2
!
        endif
!
30      continue
!
    endif
!
    call jedema()
!
end subroutine
