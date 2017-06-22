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

subroutine cfgcpc(resoco, matass, solveu, neq, nbliai,&
                  precon, tole, premax, epsi)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfpcdi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/r8inir.h"
#include "blas/dcopy.h"
    character(len=24) :: resoco
    character(len=16) :: precon
    integer :: neq, nbliai
    character(len=19) :: matass, solveu
    integer :: premax
    real(kind=8) :: tole, epsi
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - GCP)
!
! PRECONDITIONNEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  SOLVEU : SD SOLVEUR
! IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  PRECON : TYPE DE PRECONDITIONNEMENT
!              'DIRICHLET'
!              'SANS'
! IN  TOLE   : TOLERANCE POUR DETECTER PRESSION NULLE
! IN  PREMAX : NOMBRE MAXI D'ITERATIONS DU SOLVEUR ITERATIF
! IN  EPSI   : RESI_ABSO
!
!
!
!
    character(len=19) :: sgradp, sgrprp
    integer :: jsgrap, jsgprp
    character(len=24) :: apcoef, apddl, appoin
    integer :: japcoe, japddl, japptr
    character(len=19) :: mu, liac
    integer :: jmu, jliac
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = resoco(1:14)//'.APPOIN'
    apcoef = resoco(1:14)//'.APCOEF'
    apddl = resoco(1:14)//'.APDDL'
    mu = resoco(1:14)//'.MU'
    sgradp = resoco(1:14)//'.SGDP'
    liac = resoco(1:14)//'.LIAC'
    sgrprp = resoco(1:14)//'.SGPP'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(mu, 'L', jmu)
    call jeveuo(sgradp, 'L', jsgrap)
    call jeveuo(liac, 'E', jliac)
    call jeveuo(sgrprp, 'E', jsgprp)
!
! --- INITIALISATION DU PRECONDITIONNEUR
!
    call r8inir(nbliai, 0.d0, zr(jsgprp), 1)
!
! --- PRECONDITIONNEMENT (OU PAS)
!
    if (precon .eq. 'DIRICHLET') then
        call cfpcdi(resoco, neq, nbliai, tole, epsi,&
                    zr(jmu), zr( japcoe), zi(japddl), zi(japptr), zi(jliac),&
                    matass, solveu, premax, zr(jsgrap), zr(jsgprp))
    else if (precon.eq.'SANS') then
        call dcopy(nbliai, zr(jsgrap), 1, zr(jsgprp), 1)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
