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

subroutine surfcp(sdcont, unit_msg)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: unit_msg
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Print debug for all formulations
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  unit_msg         : logical unit for messages (print)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cont_form, algo_cont, algo_frot
    character(len=24) :: sdcont_defi
    integer :: cont_mult, frot_maxi, geom_maxi, cont_maxi
    integer :: geom_nbiter
    real(kind=8) :: geom_resi, frot_resi
    integer :: algo_reso_cont, algo_reso_frot, algo_reso_geom
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Parameters
!
    cont_form      = cfdisi(sdcont_defi,'FORMULATION')
    algo_cont      = cfdisi(sdcont_defi,'ALGO_CONT')
    algo_frot      = cfdisi(sdcont_defi,'ALGO_FROT')
    algo_reso_cont = cfdisi(sdcont_defi,'ALGO_RESO_CONT')
    algo_reso_frot = cfdisi(sdcont_defi,'ALGO_RESO_FROT')
    algo_reso_geom = cfdisi(sdcont_defi,'ALGO_RESO_GEOM')
    geom_nbiter    = cfdisi(sdcont_defi,'NB_ITER_GEOM')
    geom_maxi      = cfdisi(sdcont_defi,'ITER_GEOM_MAXI')
    geom_resi      = cfdisr(sdcont_defi,'RESI_GEOM')
    cont_mult      = cfdisi(sdcont_defi,'ITER_CONT_MULT')
    cont_maxi      = cfdisi(sdcont_defi,'ITER_CONT_MAXI')
    frot_maxi      = cfdisi(sdcont_defi,'ITER_FROT_MAXI')
    frot_resi      = cfdisr(sdcont_defi,'RESI_FROT')
!
! - User print
!
    write (unit_msg,*)
    write (unit_msg,*) '<CONTACT> INFOS GENERALES'
    write (unit_msg,*)
!
! - Contact formulation
!
    write (unit_msg,*) '<CONTACT> FORMULATION'
    if (cont_form .eq. 1) then
        write (unit_msg,*) '<CONTACT> ... FORMULATION DISCRETE (MAILLEE)'
    else if (cont_form.eq.2) then
        write (unit_msg,*) '<CONTACT> ... FORMULATION CONTINUE (MAILLEE)'
    else if (cont_form.eq.3) then
        write (unit_msg,*) '<CONTACT> ... FORMULATION XFEM (NON MAILLEE)'
    else
        ASSERT(.false.)
    endif
!
! - Algorithms
!
    write (unit_msg,*) '<CONTACT> MODELE'
    write (unit_msg,170) 'ALGO_CONT       ',algo_cont
    write (unit_msg,170) 'ALGO_FROT       ',algo_frot
!
! - Geometry algorithm and parameters
!
    write (unit_msg,*) '<CONTACT> ALGORITHMES'
    if (algo_reso_geom .eq. 0) then
        write (unit_msg,*) '<CONTACT> ... ALGO. GEOMETRIQUE - POINT FIXE'
        if (geom_nbiter .eq. 0) then
            write (unit_msg,*) '<CONTACT> ...... PAS DE REAC. GEOM.'
        else if (geom_nbiter .eq. -1) then
            write (unit_msg,*) '<CONTACT> ...... REAC. GEOM. AUTO.'
        else
            write (unit_msg,*) '<CONTACT> ...... REAC. GEOM. MANUEL: ',geom_nbiter
        endif
        write (unit_msg,170) 'ITER_GEOM_MAXI  ',geom_maxi
        write (unit_msg,171) 'RESI_GEOM       ',geom_resi
        write (unit_msg,170) 'NB_ITER_GEOM    ',geom_nbiter
    else if (algo_reso_geom .eq. 1) then
        write (unit_msg,*) '<CONTACT> ... ALGO. GEOMETRIQUE - NEWTON'
        write (unit_msg,171) 'RESI_GEOM       ',geom_resi
    else
        ASSERT(.false.)
    endif
!
! - Friction algorithm and parameters
!
    if (algo_reso_frot .eq. 0) then
        write (unit_msg,*) '<CONTACT> ... ALGO. FROTTEMENT - POINT FIXE'
        write (unit_msg,170) 'ITER_FROT_MAXI  ',frot_maxi
        write (unit_msg,171) 'RESI_FROT       ',frot_resi
    else if (algo_reso_frot .eq. 1) then
        write (unit_msg,*) '<CONTACT> ... ALGO. FROTTEMENT - NEWTON'
        write (unit_msg,171) 'RESI_FROT       ',frot_resi
    else
        ASSERT(.false.)
    endif
!
! - Contact algorithm and parameters
!
    if (algo_reso_cont .eq. 0) then
        write (unit_msg,*) '<CONTACT> ... ALGO. CONTACT - POINT FIXE'
        write (unit_msg,170) 'ITER_CONT_MULT  ',cont_mult
        write (unit_msg,170) 'ITER_CONT_MAXI  ',cont_maxi
    else if (algo_reso_cont .eq. 1) then
        write (unit_msg,*) '<CONTACT> ... ALGO. CONTACT - NEWTON'
    else
        ASSERT(.false.)
    endif
!
170 format (' <CONTACT> ...... PARAM. : ',a16,' - VAL. : ',i5)
171 format (' <CONTACT> ...... PARAM. : ',a16,' - VAL. : ',e12.5)
!
end subroutine
